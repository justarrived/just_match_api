# frozen_string_literal: true

module Api
  module V1
    module Users
      class RatingsController < BaseController
        after_action :verify_authorized, except: %i(index)

        before_action :set_user

        resource_description do
          resource_id 'user_ratings'
          short 'API for user ratings'
          name 'User ratings'
          description '
            Here you can find the documentation for interacting with user ratings.
          '
          formats [:json]
          api_versions '1.0'
        end

        ALLOWED_INCLUDES = %w().freeze

        api :GET, '/users/:user_id/ratings', 'Shows all ratings for user'
        description 'Returns the ratings for a user if the user is allowed.'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self, Index::RatingsIndex)
        example Doxxer.read_example(Rating, plural: true, meta: { 'average-score' => 4.3 }) # rubocop:disable Metrics/LineLength
        def index
          authorize_index(@user)

          ratings_scope = Rating.received_ratings(@user)
          ratings_index = Index::RatingsIndex.new(self)
          @ratings = ratings_index.ratings(ratings_scope)

          meta = { 'average-score': @ratings.average_score(round: 2) }
          api_render(@ratings, total: ratings_index.count, meta: meta)
        end

        private

        def set_user
          @user = User.find(params[:user_id])
        end

        def authorize_index(user)
          raise Pundit::NotAuthorizedError unless policy(user).ratings?
        end
      end
    end
  end
end
