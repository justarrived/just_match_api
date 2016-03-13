# frozen_string_literal: true
class JsonApiSerializer
  attr_reader :serializer, :included

  def self.serialize(*args)
    new(*args).serialize
  end

  def initialize(model_or_model_array, included:)
    @model_or_model_array = model_or_model_array
    @included = included
    @serializer = ActiveModel::Serializer.serializer_for(model_or_model_array)
  end

  def serializer_instance
    if @model_or_model_array.respond_to?(:to_ary)
      serializer.new(@model_or_model_array, each_serializer: serializer)
    else
      serializer.new(@model_or_model_array)
    end
  end

  def serialize
    ActiveModel::Serializer::Adapter.create(serializer_instance, include: included)
  end
end
