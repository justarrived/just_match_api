# frozen_string_literal: true
require 'seeds/dev/base_seed'

class SkillSeed < BaseSeed
  def self.call(languages:)
    max_skills = max_count_opt('MAX_SKILLS', 10)

    log '[db:seed] Skill'
    max_skills.times do
      Skill.create!(name: Faker::Name.title, language: languages.sample)
    end
  end
end
