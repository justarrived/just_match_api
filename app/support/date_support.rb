# frozen_string_literal: true

module DateSupport
  def self.days_in(start, finish)
    (start.to_date..finish.to_date).to_a
  end

  def self.weekdays_in(start, finish)
    (start.to_date..finish.to_date).select { |date| (1..5).cover?(date.wday) }
  end
end
