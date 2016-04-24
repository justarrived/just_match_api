# frozen_string_literal: true
module DateSupport
  def self.days_appart(start, finish)
    (finish.to_date - start.to_date).to_i
  end

  def self.weekdays_in(start, finish)
    (start.to_date..finish.to_date).select { |date| (1..5).include?(date.wday) }
  end
end
