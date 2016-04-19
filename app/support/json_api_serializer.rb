# frozen_string_literal: true
class JsonApiSerializer
  attr_reader :serializer, :included, :current_user, :model_scope, :meta

  def self.serialize(*args)
    new(*args).serialize
  end

  def initialize(model_scope, included: [], current_user: nil, meta: {})
    @model_scope = model_scope
    @included = included
    @meta = meta
    @current_user = current_user
    @serializer = ActiveModel::Serializer.serializer_for(model_scope)
  end

  def serializer_instance
    serializer_options = { scope: { current_user: current_user } }

    if @model_scope.respond_to?(:to_ary)
      serializer_options[:each_serializer] = serializer
    end

    serializer.new(@model_scope, serializer_options)
  end

  def serialize
    ActiveModelSerializers::Adapter.create(
      serializer_instance,
      include: included,
      meta: meta
    )
  end
end
