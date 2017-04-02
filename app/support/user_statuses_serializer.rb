# frozen_string_literal: true
class UserStatusesSerializer
  def self.serializeble_resource(key_transform:)
    language_id = Language.find_by_locale(I18n.locale)&.id

    statuses_data = User::STATUSES.map do |status_name, _status_id|
      attributes = {}
      attributes.merge!(deprecated_resource_values_hash(status_name))

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
        relationships: relationships,
        key_transform: key_transform
      )
    end
    JsonApiDatum.new(statuses_data)
  end

  def self.deprecated_resource_values_hash(status_name)
    ActiveSupport::Deprecation.warn('This method is deprecated and will be removed.')

    attributes = {}
    I18n.available_locales.each do |locale|
      name = I18n.t("user.statuses.#{status_name}", locale: locale)
      description = I18n.t("user.statuses.#{status_name}_description", locale: locale)

      attributes[:"#{locale}_name"] = name
      attributes[:"#{locale}_description"] = description
    end
    attributes
  end
end
