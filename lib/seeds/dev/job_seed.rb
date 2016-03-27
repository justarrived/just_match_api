# frozen_string_literal: true
require 'seeds/dev/base_seed'

module Dev
  class JobSeed < BaseSeed
    def self.call(languages:, users:, addresses:, skills:, categories:)
      max_jobs = max_count_opt('MAX_JOBS', 30)
      max_job_comments = max_count_opt('MAX_JOB_COMMENTS', 20)

      log '[db:seed] Job'
      rates = Job::ALLOWED_RATES

      max_jobs.times do
        address = addresses.sample
        hours = (3..10).to_a.sample
        job = Job.create!(
          name: Faker::Name.name,
          max_rate: rates.sample,
          description: Faker::Hipster.paragraph(2),
          job_date: (1..10).to_a.sample.days.from_now,
          owner: users.sample,
          street: address[:street],
          zip: address[:zip],
          hours: hours,
          language: languages.sample,
          category: categories.sample
        )
        if [0, 1].sample.even?
          job.job_date = (1..10).to_a.sample.days.ago
          job.save(validate: false)
        end

        job.skills << skills.sample
        Random.rand(1..max_job_comments).times do
          Comment.create!(
            body: Faker::Company.bs,
            owner_user_id: users.sample.id,
            commentable: job,
            language: languages.sample
          )
        end
      end
    end
  end
end
