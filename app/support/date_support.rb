# frozen_string_literal: true
module DateSupport
  def self.days_appart(start, finish)
    (finish.to_date - start.to_date).to_i
  end
end
