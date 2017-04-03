# frozen_string_literal: true
module Api
  module V1
    module Users
      class UserInterestsController < BaseController
        before_action :set_user
        before_action :set_user_interest, only: [:show, :destroy]
        before_action :set_interest, only: [:show, :destroy]

        resource_description do
          resource_id 'user_interests'
          short 'API for managing user interests'
          name 'User interests'
          description '
            User interests is the relationship between a user and a interest.
          '
          formats [:json]
          api_versions '1.0'
        end

        ALLOWED_INCLUDES = %w(user interest).freeze

        api :GET, '/users/:user_id/interests', 'Show user interests'
        description 'Returns list of user interests if the user is allowed.'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self, Index::UserInterestsIndex)
        example Doxxer.read_example(UserInterest, plural: true)
        def index
          authorize(UserInterest)

          user_interests_index = Index::UserInterestsIndex.new(self)
          scope = @user.user_interests.visible
          @user_interests = user_interests_index.user_interests(scope)

          api_render(@user_interests, total: user_interests_index.count)
        end

        api :GET, '/users/:user_id/interests/:user_interest_id', 'Show user interest'
        description 'Returns user interest if the user is allowed.'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self)
        example Doxxer.read_example(UserInterest)
        def show
          authorize(UserInterest)

          api_render(@user_interest)
        end

        api :POST, '/users/:user_id/interests/', 'Create new user interest'
        description 'Creates and returns new user interest if the user is allowed.'
        error code: 400, desc: 'Bad request'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        ApipieDocHelper.params(self)
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Interest attributes', required: true do
            param :id, Integer, desc: 'Interest id', required: true
            param :level, UserInterest::LEVEL_RANGE.to_a, desc: 'Interest level'
          end
        end
        example Doxxer.read_example(UserInterest, method: :create)
        def create
          @user_interest = UserInterest.new
          @user_interest.user = @user

          authorize(@user_interest)

          @user_interest.interest = Interest.find_by(id: interest_params[:id])
          @user_interest.level = interest_params[:level]

          if @user_interest.save
            api_render(@user_interest, status: :created)
          else
            api_render_errors(@user_interest)
          end
        end

        api :DELETE, '/users/:user_id/interests/:user_interest_id', 'Delete user interest'
        description 'Deletes user interest if the user is allowed.'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        def destroy
          authorize(@user_interest)

          @user_interest.destroy unless @user_interest.touched_by_admin?

          head :no_content
        end

        private

        def set_user
          @user = User.find(params[:user_id])
        end

        def set_interest
          @interest = @user_interest.interest
        end

        def set_user_interest
          @user_interest = @user.user_interests.find(params[:user_interest_id])
        end

        def interest_params
          jsonapi_params.permit(:id, :level)
        end

        def pundit_user
          UserInterestPolicy::Context.new(current_user, @user)
        end
      end
    end
  end
end
