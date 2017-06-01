# frozen_string_literal: true

class MissingUserTraitsSerializer
  def self.serialize(user_attributes:, skills: [], languages: [], skills_hint: nil, languages_hint: nil) # rubocop:disable Metrics/LineLength
    attributes = {}
    user_attributes.each { |name| attributes[name] = {} }

    if skills.any?
      attributes[:skill_ids] = { ids: skills.map(&:id), hint: skills_hint }
    end

    if languages.any?
      attributes[:language_ids] = { ids: languages.map(&:id), hint: languages_hint }
    end

    JsonApiData.new(
      id: SecureGenerator.token(length: 32),
      type: :missing_user_traits,
      attributes: attributes
    )
  end
end
