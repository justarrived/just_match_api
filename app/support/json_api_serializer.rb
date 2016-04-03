# frozen_string_literal: true
class JsonApiSerializer
  attr_reader :serializer, :included, :current_user

  def self.serialize(*args)
    new(*args).serialize
  end

  def initialize(model_or_model_array, included: [], current_user: nil)
    @model_or_model_array = model_or_model_array
    @included = included
    @current_user = current_user
    @serializer = ActiveModel::Serializer.serializer_for(model_or_model_array)
  end

  def serializer_instance
    serializer_options = { scope: { current_user: current_user } }

    if @model_or_model_array.respond_to?(:to_ary)
      serializer_options[:each_serializer] = serializer
    end

    serializer.new(@model_or_model_array, serializer_options)
  end

  def serialize
    ActiveModel::Serializer::Adapter.create(serializer_instance, include: included)
  end
end
