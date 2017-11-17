# frozen_string_literal: true

module Api
  module V1
    module Users
      class UserOccupationsController < BaseController
        before_action :set_user
        before_action :set_user_occupation, only: %i(show destroy)
        before_action :set_occupation, only: %i(show destroy)

        resource_description do
          resource_id 'user_occupations'
          short 'API for managing user occupations'
          name 'User occupations'
          description '
            User occupations is the relationship between a user and a occupations.
          '
          formats [:json]
          api_versions '1.0'
        end

        ALLOWED_INCLUDES = %w(user occupation).freeze

        api :GET, '/users/:user_id/occupations', 'Show user occupations'
        description 'Returns list of user occupations if the user is allowed.'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self, Index::UserOccupationsIndex)
        example Doxxer.read_example(UserOccupation, plural: true)
        def index
          authorize(UserOccupation)

          user_occupations_index = Index::UserOccupationsIndex.new(self)
          @user_occupations = user_occupations_index.user_occupations(@user.user_occupations)

          api_render(@user_occupations, total: user_occupations_index.count)
        end

        api :GET, '/users/:user_id/occupations/:user_occupation_id', 'Show user occupation'
        description 'Returns user occupation if the user is allowed.'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self)
        example Doxxer.read_example(UserOccupation)
        def show
          authorize(UserOccupation)

          api_render(@user_occupation)
        end

        api :POST, '/users/:user_id/occupations/', 'Create new user occupation'
        description 'Creates and returns new user occupation if the user is allowed.'
        error code: 400, desc: 'Bad request'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        ApipieDocHelper.params(self)
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Occupation attributes', required: true do
            param :id, Integer, desc: 'Occupation id', required: true
            param :years_of_experience, (1..100).to_a, desc: 'Years of experience'
          end
        end
        example Doxxer.read_example(UserOccupation, method: :create)
        def create
          @user_occupation = UserOccupation.new
          @user_occupation.user = @user

          authorize(@user_occupation)

          @user_occupation.occupation = Occupation.find_by(id: occupation_params[:id])
          @user_occupation.years_of_experience = occupation_params[:years_of_experience]

          if @user_occupation.save
            api_render(@user_occupation, status: :created)
          else
            api_render_errors(@user_occupation)
          end
        end

        api :DELETE, '/users/:user_id/occupations/:user_occupation_id', 'Delete user occupation'
        description 'Deletes user occupation if the user is allowed.'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        def destroy
          authorize(@user_occupation)

          @user_occupation.destroy

          head :no_content
        end

        private

        def set_user
          @user = User.find(params[:user_id])
        end

        def set_occupation
          @occupation = @user_occupation.occupation
        end

        def set_user_occupation
          @user_occupation = @user.user_occupations.find(params[:user_occupation_id])
        end

        def occupation_params
          jsonapi_params.permit(:id, :years_of_experience)
        end

        def pundit_user
          UserOccupationPolicy::Context.new(current_user, @user)
        end
      end
    end
  end
end
