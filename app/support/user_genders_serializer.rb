# frozen_string_literal: true
class UserGendersSerializer
  def self.serializeble_resource
    language_id = Language.find_by_locale(I18n.locale)&.id

    genders_data = User::GENDER.map do |gender_name, _status_id|
      locale = I18n.locale
      name = I18n.t("user.genders.#{gender_name}", locale: locale)
      attributes = { name: name, language_id: language_id }

      attributes[:translated_text] = {
        name: name,
        language_id: language_id
      }

      relationships = JsonApiRelationships.new
      relationships.add(relation: 'language', type: 'languages', id: language_id)

      JsonApiData.new(
        id: gender_name,
        type: :user_genders,
        attributes: attributes,
        relationships: relationships,
        key_transform: :underscore
      )
    end
    JsonApiDatum.new(genders_data)
  end
end
