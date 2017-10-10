# frozen_string_literal: true

namespace :digests do
  task :new_companies, %i[] => %i[environment] do |_t, _args|
    email = AppConfig.new_companies_digest_receiver_email

    if email.present?
      companies = Company.after(:created_at, 24.hours.ago).limit(25).to_a

      envelope = CompanyMailer.new_companies_digest_email(
        email: email,
        companies: companies
      )

      DeliverNotification.call(envelope, I18n.locale)
    end
  end

  namespace :job_alerts do
    task :weekly, %i[weekday] => %i[environment] do |_t, args|
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

    task daily: :environment do
      SendLatestJobDigestService.call(jobs_published_within_hours: 24)
    end
  end
end
