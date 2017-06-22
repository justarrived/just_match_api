# frozen_string_literal: true

require 'seeds/base_seed'

module Dev
  class JobSeed < BaseSeed
    def self.call(languages:, users:, addresses:, skills:, categories:, hourly_pays:)
      max_jobs = max_count_opt('MAX_JOBS', 30)
      max_job_comments = max_count_opt('MAX_JOB_COMMENTS', 20)

      log_seed(Job, Comment) do
        max_jobs.times do
          address = addresses.sample
          job_date_days = (6..13).to_a.sample

          job_date = job_date_days.days.from_now
          job_end_date = (job_date_days + 5).days.from_now

          weekdays_appart = DateSupport.weekdays_in(job_date, job_end_date).length
          # Calculdate valid hours per day spread
          hours = ((weekdays_appart * 1)..(weekdays_appart * 12)).to_a.sample

          name = Faker::Name.name
          description = Faker::Hipster.paragraph(2)
          short_description = Faker::Hipster.paragraph(1)
          job = Job.create!(
            name: name,
            description: description,
            short_description: short_description,
            publish_at: Time.zone.now,
            job_date: job_date,
            job_end_date: job_end_date,
            owner: users.sample,
            street: address[:street],
            zip: address[:zip],
            hours: hours,
            language: languages.sample,
            category: categories.sample,
            hourly_pay: hourly_pays.sample
          )
          job.set_translation(
            name: name,
            description: description,
            short_description: short_description
          )

          if [0, 1].sample.even?
            job_date_days = (6..13).to_a.sample
            job.job_date = job_date_days.days.ago
            job.job_end_date = (job_date_days.days - 5).ago
            job.save(validate: false)
          end

          job.skills << skills.sample
          Random.rand(1..max_job_comments).times do
            body = Faker::Company.bs
            comment = Comment.create!(
              body: body,
              owner_user_id: users.sample.id,
              commentable: job,
              language: languages.sample
            )
            comment.set_translation(body: body)
          end
        end
      end
    end
  end
end
