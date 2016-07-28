# frozen_string_literal: true
module JsonApiHelpers
  module AMS
    # NOTE:
    #   For some weird reason, ActiveModelSerializers call #original_url on
    #   ActionDispatch::Request, which isn't defined. In order to avoid monkey matching,
    #   this wrapper object delegates all methods to the request object and only adds one
    #   method #request_url
    class ActionDispatchRequestWrapper < Delegator
      attr_reader :action_dispatch_request

      def initialize(request)
        super
        @action_dispatch_request = request
      end

      def __getobj__
        @action_dispatch_request
      end

      def __setobj__(request)
        @action_dispatch_request = request
      end

      def request_url
        @action_dispatch_request.original_url
      end
    end
  end
end
