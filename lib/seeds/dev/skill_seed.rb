# frozen_string_literal: true
require 'seeds/dev/base_seed'

module Dev
  class SkillSeed < BaseSeed
    def self.call
      max_skills = max_count_opt('MAX_SKILLS', 30)

      language = Language.find_by!(lang_code: 'en')

      log '[db:seed] Skill'
      max_skills.times do
        Skill.create!(name: Faker::Name.title, language: language)
      end
    end
  end
end
