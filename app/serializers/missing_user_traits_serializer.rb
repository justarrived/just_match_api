# frozen_string_literal: true

class MissingUserTraitsSerializer
  def self.serialize(
    user_attributes:,
    skills: [],
    languages: [],
    occupations: [],
    skills_hint: nil,
    languages_hint: nil,
    occupations_hint: nil,
    missing_cv: false
  )
    attributes = {}
    attributes[:cv] = {} if missing_cv

    user_attributes.each { |name| attributes[name] = {} }

    if languages.any?
      attributes[:language_ids] = { ids: languages.map(&:id), hint: languages_hint }
    end

    if occupations.any?
      attributes[:occupation_ids] = { ids: occupations.map(&:id), hint: occupations_hint }
    end

    if skills.any?
      attributes[:skill_ids] = { ids: skills.map(&:id), hint: skills_hint }
    end

    JsonApiData.new(
      id: SecureGenerator.token(length: 32),
      type: :missing_user_traits,
      attributes: attributes
    )
  end
end
