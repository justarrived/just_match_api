# frozen_string_literal: true
require 'seeds/dev/chat_seed'
require 'seeds/dev/job_seed'
require 'seeds/dev/job_user_seed'
require 'seeds/dev/language_seed'
require 'seeds/dev/skill_seed'
require 'seeds/dev/user_seed'

namespace :dev do
  task seed: :environment do
    addresses = [
      { street: "Stora Nygatan #{Random.rand(1..40)}", zip: '21137' },
      { street: "Wollmar Yxkullsgatan #{Random.rand(1..40)}", zip: '11850' }
    ]

    LanguageSeed.call
    languages = Language.all

    SkillSeed.call(languages: languages)
    skills = Skill.all

    UserSeed.call(languages: languages, skills: skills, addresses: addresses)
    users = User.all

    JobSeed.call(languages: languages, users: users, addresses: addresses, skills: skills)
    jobs = Job.all

    JobUserSeed.call(jobs: jobs, users: users)
    ChatSeed.call(users: users)
  end

  task doc_examples: :environment do
    Doxxer.generate_response_examples
  end
end
