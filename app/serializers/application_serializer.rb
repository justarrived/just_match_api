# frozen_string_literal: true
class ApplicationSerializer < ActiveModel::Serializer
  # include ActionView::Helpers::TextHelper # needed for #simple_format

  delegate :text_to_html, to: :value_formatter

  # Returns true if the resource is rendered as a collection
  def collection_serializer?
    !instance_options[:each_serializer].nil?
  end

  def value_formatter
    @value_formatter ||= ValueFormatter.new
  end
end
