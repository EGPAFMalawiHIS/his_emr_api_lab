# frozen_string_literal: true

module Lab
  ##
  # Manage tests that have been ordered through the ordering service.
  module TestsService
    class << self
      def find_tests(filters)
        tests = Lab::LabTest.all
        patient_id = filters.delete(:patient_id)
        patient_id ||= ::Patient.find(filters.delete(:patient))&.id if filters[:patient]

        Lab::UpdatePatientOrdersJob.perform_later(patient_id) if patient_id

        tests = filter_tests(tests, test_type_id: filters.delete(:test_type_id),
                                    patient_id: filters.delete(:patient_id),
                                    patient: filters.delete(:patient)
                                    )

        tests = filter_tests_by_results(tests) if %w[1 true].include?(filters[:pending_results]&.downcase)

        tests = filter_tests_by_order(tests, accession_number: filters.delete(:accession_number),
                                             order_date: filters.delete(:order_date),
                                             specimen_type_id: filters.delete(:specimen_type_id))

        tests.map { |test| Lab::TestSerializer.serialize(test) }
      end

      def create_tests(order, date, tests_params)
        raise InvalidParameterError, 'tests are required' if tests_params.nil? || tests_params.empty?

        
        Lab::LabTest.transaction do
          tests_params.map do |params|
            concept_id = params[:concept_id]
            concept_id = Concept.find_concept_by_uuid(params[:concept]).id if concept_id.nil?
            
            test = Lab::LabTest.create!(
              concept_id: ConceptName.find_by_name!(Lab::Metadata::TEST_TYPE_CONCEPT_NAME)
                                     .concept_id,
              encounter_id: order.encounter_id,
              order_id: order.order_id,
              person_id: order.patient_id,
              obs_datetime: date&.to_time || Time.now,
              value_coded: concept_id
            )

            Lab::TestSerializer.serialize(test, order:)
          end
        end
      end

      private

      ##
      # Filter a LabTests Relation.
      def filter_tests(tests, test_type_id: nil, patient_id: nil, patient: nil)
        tests = tests.where(value_coded: test_type_id) if test_type_id
        tests = tests.where(person_id: patient_id) if patient_id
        person = ::Person.find_by_uuid(patient) if patient
        tests = tests.where(person_id: person&.patient&.id) if patient

        tests
      end

      ##
      # Filter out any tests having results
      def filter_tests_by_results(tests)
        tests.where.not(obs_id: Lab::LabResult.all.select(:obs_group_id))
      end

      ##
      # Filter LabTests Relation using their parent orders parameters.
      def filter_tests_by_order(tests, accession_number: nil, order_date: nil, specimen_type_id: nil)
        return tests unless accession_number || order_date || specimen_type_id

        lab_orders = filter_orders(Lab::LabOrder.all, accession_number:,
                                                      order_date:,
                                                      specimen_type_id:)
        tests.joins(:order).merge(lab_orders)
      end

      def filter_orders(orders, accession_number: nil, order_date: nil, specimen_type_id: nil)
        if order_date
          order_date = order_date.to_date
          orders = orders.where('start_date >= ? AND start_date < ?', order_date, order_date + 1.day)
        end

        orders = orders.where(accession_number:) if accession_number
        orders = orders.where(concept_id: specimen_type_id) if specimen_type_id

        orders
      end

      def create_test(order, date, test_type_id)
        create_order_observation(
          order,
          Lab::Metadata::TEST_TYPE_CONCEPT_NAME,
          date,
          value_coded: test_type_id
        )
      end

      def create_initial_test_status_trail(test, date)
        # Find concept
        test_status_concept = ConceptName.find_by(name: 'Lab Test Status')&.concept

        unless test_status_concept
          Rails.logger.warn('Missing Lab Test Status concept')
          return
        end

        # Create status observation with 'Drawn' as initial status
        Observation.create!(
          person_id: test.person_id,
          encounter_id: test.encounter_id,
          obs_group_id: test.obs_id, # Link to parent test observation
          concept_id: test_status_concept.concept_id,
          value_text: 'Drawn', # Store status as text
          obs_datetime: date || test.obs_datetime || Time.now,
          comments: {
            'first_name' => User.current&.person&.names&.first&.given_name,
            'last_name' => User.current&.person&.names&.first&.family_name,
            'id' => User.current&.user_id&.to_s,
            'phone_number' => nil
          }.to_json,
          creator: User.current&.user_id || 1,
          date_created: Time.now,
          uuid: SecureRandom.uuid
        )
      rescue StandardError => e
        Rails.logger.warn("Failed to create initial test status trail: #{e.message}")
      end
    end
  end
end
