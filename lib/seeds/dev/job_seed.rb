# frozen_string_literal: true
require 'seeds/dev/base_seed'

class JobSeed < BaseSeed
  def self.call(languages:, users:, addresses:, skills:)
    max_jobs = max_count_opt('MAX_JOBS', 10)
    max_job_comments = max_count_opt('MAX_JOB_COMMENTS', 10)

    log '[db:seed] Job'
    days_from_now_range = (1..10).to_a
    rates = (100..1000).to_a

    max_jobs.times do
      address = addresses.sample
      hours = (3..10).to_a.sample
      job = Job.create!(
        name: Faker::Name.name,
        max_rate: rates.sample,
        description: Faker::Hipster.paragraph(2),
        job_date: days_from_now_range.sample.days.from_now,
        owner: users.sample,
        street: address[:street],
        zip: address[:zip],
        hours: hours,
        language: languages.sample
      )
      job.skills << skills.sample
      Random.rand(1..max_job_comments).times do
        Comment.create!(
          body: Faker::Company.bs,
          owner_user_id: users.sample.id,
          commentable: users.sample,
          language: languages.sample
        )
      end
    end
  end
end
