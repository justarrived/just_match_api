# frozen_string_literal: true
class UserImageCategoriesSerializer
  def self.serializeble_resource(key_transform:)
    language_id = Language.find_by(lang_code: I18n.locale)&.id
    notifications_data = UserImage::CATEGORIES.map do |category_name, _value|
      name = I18n.t("user_image.categories.#{category_name}")
      description = I18n.t("user_image.categories.#{category_name}_description")
      attributes = {
        name: name,
        description: description,
        language_id: language_id,
        translated_text: {
          name: name,
          description: description,
          language_id: language_id
        }
      }
      JsonApiData.new(
        id: category_name,
        type: :user_image_categories,
        attributes: attributes,
        key_transform: key_transform
      )
    end

    JsonApiDatum.new(notifications_data)
  end
end
