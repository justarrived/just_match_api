# frozen_string_literal: true
class UserStatusesSerializer
  def self.serializeble_resource
    language_id = Language.find_by_locale(I18n.locale)&.id

    statuses_data = User::STATUSES.map do |status_name, _status_id|
      attributes = {}

      locale = I18n.locale
      name = I18n.t("user.statuses.#{status_name}", locale: locale)
      description = I18n.t("user.statuses.#{status_name}_description", locale: locale)
      attributes[:name] = name
      attributes[:description] = description
      attributes[:language_id] = language_id
      attributes[:translated_text] = {
        name: name,
        description: description,
        language_id: language_id
      }

      relationships = JsonApiRelationships.new
      relationships.add(relation: 'language', type: 'languages', id: language_id)

      JsonApiData.new(
        id: status_name,
        type: :user_statuses,
        attributes: attributes,
        relationships: relationships
      )
    end
    JsonApiDatum.new(statuses_data)
  end
end
