# frozen_string_literal: true

# notification service
class Lab::NotificationService
  # this gets all uncleared notifications of the user
  def uncleared
    NotificationAlert.joins(:notification_alert_recipients).where(
      'notification_alert_recipient.user_id = ?', User.current.user_id
    )
  end

  def clear(alert_id)
    alert = NotificationAlert.find(alert_id)
    # update the notification alert recipient to cleared and read only for the current user
    alert.notification_alert_recipients.where(user_id: User.current.user_id).update_all(cleared: true, alert_read: true)
  end

  # this updates the notification to read
  def read(alerts)
    alerts.each do |alert|
      notification = NotificationAlertRecipient.where(user_id: User.current.user_id, alert_id: alert,
                                                      alert_read: false).first
      next if notification.blank?

      notification.alert_read = true
      notification.save
    end
  end

  def create_notification(alert_type, alert_message,
                          uniq_checkers: { test_type_id: nil, order_id: nil, specimen_id: nil })
    return if alert_type != 'LIMS'

    test_type_id = uniq_checkers[:test_type_id]
    order_id = uniq_checkers[:order_id]
    specimen_id = uniq_checkers[:specimen_id]

    return unless test_type_id.present? && order_id.present? && specimen_id.present?

    lab = Lab::Lims::Utils.lab_user
    unless lab
      Rails.logger.warn('NotificationService: lab_daemon user not found, skipping notification creation')
      return
    end

    ActiveRecord::Base.transaction do
      # Atomic find or create - checks and creates in one operation
      alert = NotificationAlert.find_or_create_by!(
        test_type_id: test_type_id,
        order_id: order_id,
        specimen_id: specimen_id
      ) do |new_alert|
        # Only set these attributes on creation
        new_alert.text = alert_message.to_json
        new_alert.date_to_expire = Time.now + notification_period.days
        new_alert.creator = lab
        new_alert.changed_by = lab
        new_alert.date_created = Time.now
      end

      notify(alert, users(order_location(alert.order_id)))
    rescue ActiveRecord::RecordNotUnique
      # Handle race condition if unique constraint exists
      Rails.logger.info("Duplicate notification prevented for test_type: #{test_type_id}, order: #{order_id}, specimen: #{specimen_id}")
    rescue ActiveRecord::InvalidForeignKey => e
      Rails.logger.error("Invalid foreign key: #{e.message}")
    rescue StandardError => e
      Rails.logger.error("Unexpected error: #{e.message}")
    end
  end

  def notification_period
    result = GlobalProperty.where(property: 'notification.period')&.first
    return result.property_value.to_i if result.present?

    7 # default to 7 days
  end

  def users(location_id = nil)
    return User.joins(:roles).where(location_id: location_id).uniq if location_id.present? && User.column_names.include?('location_id')

    User.joins(:roles).uniq
  end

  def order_location(order_id)
    return nil unless Observation.column_names.include?('location_id')

    Observation.find_by(order_id: order_id)&.location_id
  end

  def notify(notification_alert, recipients)    
    recipients.each do |recipient|
      next if recipient.notification_alert_recipients.exists?(alert_id: notification_alert.id)

      recipient.notification_alert_recipients.create(
        alert_id: notification_alert.id
      )
    end
  end

  def notify_all(notification_alert, users)
    users.each do |user|
      user.notification_alert_recipients.create(
        alert_id: notification_alert.id
      )
    end
  end

  def notify_all_users(notification_alert)
    User.all.each do |user|
      user.notification_alert_recipients.create!(
        alert_id: notification_alert.id
      )
    end
  end
end
