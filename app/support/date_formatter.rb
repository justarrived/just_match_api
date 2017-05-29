# frozen_string_literal: true

class DateFormatter
  include ActionView::Helpers::DateHelper

  def distance_of_time_in_words_from_now(datetime)
    distance_of_time_in_words(Time.zone.now, datetime)
  end
end
