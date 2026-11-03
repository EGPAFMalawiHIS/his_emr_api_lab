# frozen_string_literal: true

module Lab
  ##
  # Fetches updates on a patient's orders from external sources.
  class UpdatePatientOrdersJob < ApplicationJob
    queue_as :default

    # Opening a patient's lab orders or tests queues this job, so a busy
    # patient page would otherwise sync with NLIMS on every request.
    MIN_INTERVAL_BETWEEN_RUNS = 5.minutes

    # Only orders from this window are checked; older orders are left to the
    # sync worker (bin/lab/sync_worker.rb uses the same window).
    SYNC_WINDOW = 6.months

    def perform(patient_id)
      return if ran_recently?(patient_id)

      Rails.logger.info('Initialising LIMS REST API...')

      User.current = Lab::Lims::Utils.lab_user
      # Set location from patient's most recent encounter to ensure proper context
      set_location_from_patient_encounter(patient_id)

      lockfile = Rails.root.join('tmp', "update-patient-orders-#{patient_id}.lock")

      done = File.open(lockfile, File::RDWR | File::CREAT) do |lock|
        unless lock.flock(File::LOCK_NB | File::LOCK_EX)
          Rails.logger.info('Another update patient job is already running...')
          break false
        end

        worker = Lab::Lims::PullWorker.new(Lab::Lims::ApiFactory.create_api, start_date: SYNC_WINDOW.ago)
        worker.pull_orders(patient_id:)

        true
      end

      File.unlink(lockfile) if done
    end

    private

    # Uses a file's mtime rather than Rails.cache so all Puma workers see it.
    # The file is touched before the sync starts, so a burst of requests for
    # the same patient results in a single sync.
    def ran_recently?(patient_id)
      stamp = Rails.root.join('tmp', "update-patient-orders-#{patient_id}.last_run")
      if File.exist?(stamp) && File.mtime(stamp) > MIN_INTERVAL_BETWEEN_RUNS.ago
        Rails.logger.info("Skipping LIMS update for patient #{patient_id}: last run at #{File.mtime(stamp)} and next run not due until #{File.mtime(stamp) + MIN_INTERVAL_BETWEEN_RUNS}")
        return true
      end

      FileUtils.touch(stamp)
      false
    end

    def set_location_from_patient_encounter(patient_id)
      Rails.logger.info("Setting location context for patient #{patient_id}")

      # Strategy 1: Find location from patient's most recent order (ANY order type)
      recent_order = Order.unscoped
                          .where(patient_id: patient_id)
                          .order(start_date: :desc)
                          .first

      if recent_order
        encounter = Encounter.unscoped.find_by(encounter_id: recent_order.encounter_id)
        if encounter&.location_id
          Location.current = Location.find(encounter.location_id)
          Rails.logger.info("Location set from patient's recent order: #{Location.current.name} (ID: #{Location.current.location_id})")
          return
        end
      end

      # Strategy 2: Find location from patient's most recent encounter
      recent_encounter = Encounter.unscoped
                                  .where(patient_id: patient_id)
                                  .order(encounter_datetime: :desc)
                                  .first

      if recent_encounter&.location_id
        Location.current = Location.find(recent_encounter.location_id)
        Rails.logger.info("Location set from patient's recent encounter: #{Location.current.name} (ID: #{Location.current.location_id})")
        return
      end

      # Fallback chain: Try multiple options to ensure location is ALWAYS set
      Location.current ||= begin
        Location.current_health_center
      rescue StandardError
        nil
      end
      Location.current ||= Location.first

      if Location.current
        Rails.logger.info("Location set to fallback: #{Location.current.name} (ID: #{Location.current.location_id})")
      else
        Rails.logger.error('CRITICAL: Could not set Location.current - no locations found in database!')
        raise 'No locations available in database'
      end
    end
  end
end
