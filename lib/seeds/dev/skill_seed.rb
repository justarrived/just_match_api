# frozen_string_literal: true
require 'seeds/base_seed'

module Dev
  class SkillSeed < BaseSeed
    def self.call
      max_skills = max_count_opt('MAX_SKILLS', 30)

      language = Language.find_by!(lang_code: 'en')

      log_seed(Skill) do
        max_skills.times do |n|
          name = "#{Faker::Name.title} #{n}"
          skill = Skill.create!(
            name: name,
            language: language,
            color: random_color
          )
          skill.set_translation(name: name)
        end
      end
    end

    def self.random_color
      format('#' + '%06x', (rand * 0xffffff))
    end
  end
end
