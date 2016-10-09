# frozen_string_literal: true
class GoogleCalendarUrl
  BASE_URL = 'https://www.google.com/calendar/render?'.freeze

  def self.build(name:, description:, location:, start_date:, end_date:)
    query_params = [
      'action=TEMPLATE',
      "text=#{URI.encode(name)}",
      "dates=#{format_date(start_date)}/#{format_date(end_date)}",
      "details=#{URI.encode(description&.truncate(1000))}",
      "location=#{URI.encode(location)}",
      'sf=true',
      'output=xml'
    ].join('&')

    BASE_URL + query_params
  end

  def self.format_date(date)
    date.utc.iso8601.gsub(/\+|-|:|\.\d\d\d/, '')
  end
end
