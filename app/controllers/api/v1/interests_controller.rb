# frozen_string_literal: true
module Api
  module V1
    class InterestsController < BaseController
      before_action :set_interest, only: [:show]

      resource_description do
        short 'API for managing interests'
        name 'Interests'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      ALLOWED_INCLUDES = %w(language).freeze

      api :GET, '/interests', 'List interests'
      description 'Returns a list of interests.'
      ApipieDocHelper.params(self, Index::InterestsIndex)
      example Doxxer.read_example(Interest, plural: true)
      def index
        authorize(Interest)

        interests_index = Index::InterestsIndex.new(self)
        @interests = interests_index.interests

        api_render(@interests, total: interests_index.count)
      end

      api :GET, '/interests/:id', 'Show interest'
      description 'Returns interest.'
      error code: 404, desc: 'Not found'
      ApipieDocHelper.params(self)
      example Doxxer.read_example(Interest)
      def show
        authorize(@interest)

        api_render(@interest)
      end

      private

      def set_interest
        @interest = policy_scope(Interest).find(params[:id])
      end

      def interest_params
        jsonapi_params.permit(:name, :language_id)
      end
    end
  end
end
