# frozen_string_literal: true
class UserNotificationsSerializer
  def self.serializeble_resource
    notifications_data = User::NOTIFICATIONS.map do |name|
      attributes = { description: I18n.t("notifications.#{name}") }
      JsonApiData.new(
        id: name,
        type: :user_notifications,
        attributes: attributes
      )
    end

    JsonApiDatum.new(notifications_data)
  end
end
