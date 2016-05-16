# frozen_string_literal: true
class ApplicationSerializer < ActiveModel::Serializer
  # Returns true if the resource is rendered as a collection
  def collection_serializer?
    !instance_options[:each_serializer].nil?
  end
end
