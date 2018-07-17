# frozen_string_literal: true

namespace :digests do
  task :new_companies, %i[] => %i[environment] do |task_name|
    wrap_digests_task(task_name) do
      email = AppConfig.new_companies_digest_receiver_email

      if email.present?
        companies = Company.after(:created_at, 24.hours.ago).limit(25).to_a

        unless companies.length.zero?
          envelope = CompanyMailer.new_companies_digest_email(
            email: email,
            companies: companies
          )

          DeliverNotification.call(envelope, I18n.locale)
        end
      end
    end
  end

  namespace :job_alerts do
    task :weekly, %i[weekday] => %i[environment] do |task_name, args|
      wrap_digests_task(task_name) do
        send = true

        if weekday = args[:weekday].presence
          send = false unless Time.zone.today.public_send("#{weekday.downcase}?")
        end

        if send
          SendLatestJobDigestService.call(jobs_published_within_hours: 24 * 7)
        else
          puts 'Wrong weekday! Not sending weekly digest.'
        end
      end
    end

    task daily: :environment do |task_name|
      wrap_digests_task(task_name) do
        SendLatestJobDigestService.call(jobs_published_within_hours: 24)
      end
    end
  end

  def wrap_digests_task(task_name)
    uuid = SecureRandom.uuid
    Rails.logger.info "[Digest] Running: #{task_name} #{uuid}"
    yield(uuid)
    Rails.logger.info "[Digest] Done: #{task_name} #{uuid}"
  end
end
