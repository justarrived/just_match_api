# frozen_string_literal: true
class MissingUserTraitsSerializer
  def self.serialize(user_attributes:, skills:, languages:, key_transform:)
    attributes = {}
    user_attributes.each { |name| attributes[name] = {} }
    if skills.any?
      attributes[:skill_ids] = {
        ids: skills.map(&:id),
        hint: I18n.t('user.missing_job_skills_trait')
      }
    end

    if languages.any?
      attributes[:language_ids] = {
        ids: languages.map(&:id),
        hint: I18n.t('user.missing_job_languages_trait')
      }
    end

    JsonApiData.new(
      id: SecureGenerator.token(length: 32),
      type: :missing_user_traits,
      attributes: attributes,
      key_transform: key_transform
    )
  end
end
