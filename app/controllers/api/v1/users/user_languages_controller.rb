# frozen_string_literal: true
module Api
  module V1
    module Users
      class UserLanguagesController < BaseController
        before_action :set_user
        before_action :set_language, only: [:show, :destroy]

        resource_description do
          short 'API for managing user languages'
          name 'User languages'
          description '
            User languages is the relationship between a user and a language.
          '
          formats [:json]
          api_versions '1.0'
        end

        api :GET, '/users/:user_id/languages', 'List user languages'
        description 'Returns a list of user languages.'
        def index
          authorize(UserLanguage)

          page_index = params[:page].to_i
          @languages = @user.languages.all.page(page_index)

          render json: @languages
        end

        api :GET, '/users/:user_id/languages/:id', 'Show language'
        description 'Return language.'
        example Doxxer.read_example(Language)
        def show
          authorize(UserLanguage)

          render json: @language
        end

        api :POST, '/users/:user_id/languages/', 'Create new user language'
        description 'Creates and returns new user language.'
        error code: 400, desc: 'Bad request'
        error code: 422, desc: 'Unprocessable entity'
        error code: 401, desc: 'Unauthorized'
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'User language attributes', required: true do
            param :id, Integer, desc: 'Language id', required: true
          end
        end
        example Doxxer.read_example(UserLanguage)
        def create
          @user_language = UserLanguage.new
          @user_language.user = @user

          authorize(@user_language)

          @user_language.language = Language.find_by(id: user_language_params[:id])

          if @user_language.save
            render json: @user_language, status: :created
          else
            render json: @user_language.errors, status: :unprocessable_entity
          end
        end

        api :DELETE, '/users/:user_id/languages/:id', 'Delete user language'
        description 'Deletes user language.'
        error code: 401, desc: 'Unauthorized'
        def destroy
          authorize(@user_language)

          @user_language.destroy

          head :no_content
        end

        private

        def set_user
          @user = User.find(params[:user_id])
        end

        def set_language
          @language = @user.languages.find(params[:id])
          @user_language = @user.user_languages.find_by!(language: @language)
        end

        def user_language_params
          jsonapi_params.permit(:id)
        end

        def pundit_user
          UserLanguagePolicy::Context.new(current_user, @user)
        end
      end
    end
  end
end
