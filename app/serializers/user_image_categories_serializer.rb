# frozen_string_literal: true

class UserImageCategoriesSerializer
  def self.serializable_resource
    language_id = Language.find_by_locale(I18n.locale)&.id

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

      relationships = JsonApiRelationships.new
      relationships.add(relation: 'language', type: 'languages', id: language_id)

      JsonApiData.new(
        id: category_name,
        type: :user_image_categories,
        attributes: attributes,
        relationships: relationships
      )
    end

    JsonApiDatum.new(notifications_data)
  end
end
