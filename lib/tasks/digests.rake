# frozen_string_literal: true

namespace :digests do
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
