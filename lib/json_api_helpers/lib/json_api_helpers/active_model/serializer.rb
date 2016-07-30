# frozen_string_literal: true
require 'json_api_helpers/action_dispatch_request_wrapper'

module JsonApiHelpers
  module ActiveModel
    class Serializer
      attr_reader :serializer, :included, :current_user, :model_scope, :meta, :request

      def self.serialize(*args)
        new(*args).serialize
      end

      def initialize(model_scope, included: [], current_user: nil, meta: {}, request: nil)
        @model_scope = model_scope
        @included = included
        @meta = meta
        @current_user = current_user
        # NOTE: ActiveModel::Serializer#serializer_for is from active_model_serializers
        @serializer = ActiveModel::Serializer.serializer_for(model_scope)
        @request = ActionDispatchRequestWrapper.new(request)
      end

      def serializer_instance
        serializer_options = { scope: { current_user: current_user } }

        if @model_scope.respond_to?(:to_ary)
          serializer_options[:each_serializer] = serializer
        end

        serializer.new(@model_scope, serializer_options)
      end

      def serialize
        # NOTE: ActiveModelSerializers::Adapter#create is from active_model_serializers
        ActiveModelSerializers::Adapter.create(
          serializer_instance,
          include: included,
          meta: meta,
          serialization_context: request
        )
      end
    end
  end
end
