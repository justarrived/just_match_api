# frozen_string_literal: true
require 'seeds/dev/base_seed'

module Dev
  class SkillSeed < BaseSeed
    def self.call
      max_skills = max_count_opt('MAX_SKILLS', 30)

      language = Language.find_by!(lang_code: 'en')

      before_count = Skill.count

      log 'Creating Skills'
      max_skills.times do |n|
        Skill.create!(name: "#{Faker::Name.title} #{n}", language: language)
      end

      log "Created #{Skill.count - before_count} Skills"
    end
  end
end
