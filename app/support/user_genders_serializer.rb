# frozen_string_literal: true
class UserGendersSerializer
  def self.serializeble_resource
    genders_data = User::GENDER.map do |gender_name, _status_id|
      attributes = {}

      locale = I18n.locale
      name = I18n.t("user.genders.#{gender_name}", locale: locale)
      attributes[:name] = name
      attributes[:translated_text] = { name: name }

      JsonApiData.new(
        id: gender_name,
        type: :user_genders,
        attributes: attributes,
        key_transform: :underscore
      )
    end
    JsonApiDatum.new(genders_data)
  end
end
