# frozen_string_literal: true

module Jobs
  class Dates
    attr_reader :last_application_at, :starts_at, :ends_at

    def initialize(last_application_at: nil, starts_at: nil, ends_at: nil)
      @last_application_at = last_application_at
      @starts_at = starts_at
      @ends_at = ends_at
    end

    def starts_in_the_future?
      if starts_at.nil?
        return ends_at ? ends_at > Time.zone.now : true
      end

      starts_at > Time.zone.now
    end

    def open_for_applications?
      if last_application_at
        last_application_at > Time.zone.now
      elsif ends_at
        ends_at > Time.zone.now
      else
        true
      end
    end
  end
end
