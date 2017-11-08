# frozen_string_literal: true

class UserNotificationsSerializer
  def self.serializable_resource(notifications: UserNotification.names)
    language_id = Language.find_by_locale(I18n.locale)&.id

    notifications_data = notifications.map do |name|
      description = I18n.t("notifications.#{name}")
      attributes = {
        description: description,
        language_id: language_id
      }

      attributes[:translated_text] = {
        description: description,
        language_id: language_id
      }

      relationships = JsonApiRelationships.new
      relationships.add(relation: 'language', type: 'languages', id: language_id)

      JsonApiData.new(
        id: name,
        type: :user_notifications,
        attributes: attributes,
        relationships: relationships
      )
    end

    JsonApiDatum.new(notifications_data)
  end
end
