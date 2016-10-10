# frozen_string_literal: true
class UserNotificationsSerializer
  def self.serializeble_resource(key_transform:)
    notifications_data = User::NOTIFICATIONS.map do |name|
      attributes = { description: I18n.t("notifications.#{name}") }
      JsonApiData.new(
        id: name,
        type: :user_notifications,
        attributes: attributes,
        key_transform: key_transform
      )
    end

    JsonApiDatum.new(notifications_data)
  end
end
