# frozen_string_literal: true
class GoogleCalendarUrl
  BASE_URL = 'https://www.google.com/calendar/render?'.freeze

  def self.build(name:, description:, location:, start_time:, end_time:)
    query_params = [
      'action=TEMPLATE',
      "text=#{uri_encode(name)}",
      "dates=#{format_datetime(start_time)}/#{format_datetime(end_time)}",
      "details=#{uri_encode(description&.truncate(1000))}",
      "location=#{uri_encode(location)}",
      'sf=true',
      'output=xml'
    ].join('&')

    BASE_URL + query_params
  end

  def self.format_datetime(date)
    return unless date

    date.utc.iso8601.gsub(/\+|-|:|\.\d\d\d/, '')
  end

  def self.uri_encode(text)
    URI.encode(text || '')
  end
end
