# frozen_string_literal: true
class TimeZone
  def self.cest_time(time)
    time.in_time_zone('Stockholm')
  end
end
