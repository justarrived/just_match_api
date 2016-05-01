# frozen_string_literal: true
module Api
  module V1
    module Users
      class RatingsController < BaseController
        after_action :verify_authorized, except: %i(index)

        before_action :set_user

        ALLOWED_INCLUDES = %w().freeze

        api :GET, '/users/:user_id/ratings', 'Shows all ratings for user'
        description 'Returns the ratings for a user if the user is allowed.'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self, Index::RatingsIndex)
        example Doxxer.read_example(Rating, plural: true)
        def index
          authorize_index(@user)

          ratings_index = Index::RatingsIndex.new(self)
          @ratings = ratings_index.ratings

          meta = { 'average-score': @ratings.average(:score) }
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
