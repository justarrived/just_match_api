# frozen_string_literal: true
module SetUserTraitsService
  def self.call(user:, language_ids_param:, skill_ids_param:, interest_ids_param:)
    SetUserLanguagesService.call(user: user, language_ids_param: language_ids_param)
    SetUserSkillsService.call(user: user, skill_ids_param: skill_ids_param)
    SetUserInterestsService.call(user: user, interest_ids_param: interest_ids_param)
  end
end
