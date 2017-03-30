# frozen_string_literal: true
class MissingUserTraitsSerializer
  def self.serialize(user_attributes:, skills:, languages:, key_transform:)
    attributes = {}
    user_attributes.each { |name| attributes[name] = {} }
    attributes[:skill_ids] = { ids: skills.map(&:id) } if skills.any?
    attributes[:language_ids] = { ids: languages.map(&:id) } if languages.any?

    JsonApiData.new(
      id: SecureGenerator.token(length: 32),
      type: :missing_user_traits,
      attributes: attributes,
      key_transform: key_transform
    )
  end
end
