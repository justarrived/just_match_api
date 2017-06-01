# frozen_string_literal: true

class ApplicationSerializer < ActiveModel::Serializer
  delegate :to_html, to: :string_formatter
  delegate :to_unit, to: :number_formatter
  delegate :to_delimited, to: :number_formatter
  delegate :distance_of_time_in_words_from_now, to: :date_formatter

  # Returns true if the resource is rendered as a collection
  def collection_serializer?
    !instance_options[:each_serializer].nil?
  end

  def string_formatter
    @string_formatter ||= StringFormatter.new
  end

  def number_formatter
    @number_formatter ||= NumberFormatter.new
  end

  def date_formatter
    @date_formatter ||= DateFormatter.new
  end
end
