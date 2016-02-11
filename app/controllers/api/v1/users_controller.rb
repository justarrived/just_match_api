# frozen_string_literal: true
module Api
  module V1
    class UsersController < BaseController
      SET_USER_ACTIONS = [:show, :edit, :update, :destroy, :matching_jobs, :jobs].freeze
      before_action :set_user, only: SET_USER_ACTIONS

      resource_description do
        short 'API for managing users'
        name 'Users'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      api :GET, '/users', 'List users'
      description 'Returns a list of users if the user is allowed to.'
      def index
        authorize(User)

        page_index = params[:page].to_i
        relations = [:skills, :jobs, :written_comments, :language, :languages]

        @users = User.all.page(page_index).includes(relations)
        render json: @users
      end

      api :GET, '/users/:id', 'Show user'
      description 'Returns user is alloed to.'
      example Doxxer.example_for(User)
      def show
        authorize(@user)

        render json: @user, include: allowed_includes
      end

      api :POST, '/users/', 'Create new user'
      description 'Creates and returns a new user.'
      error code: 400, desc: 'Bad request'
      error code: 422, desc: 'Unprocessable entity'
      param :user, Hash, desc: 'User attributes', required: true do
        # rubocop:disable Metrics/LineLength
        param :skill_ids, Array, of: Integer, desc: 'List of skill ids'
        param :name, String, desc: 'Name', required: true
        param :description, String, desc: 'Description', required: true
        param :email, String, desc: 'Email', required: true
        param :phone, String, desc: 'Phone', required: true
        param :street, String, desc: 'Street', required: true
        param :zip, String, desc: 'Zip code', required: true
        param :language_id, Integer, desc: 'Primary language id for user', required: true
        param :language_ids, Array, of: Integer, desc: 'Language ids of languages that the user knows', required: true
        # rubocop:enable Metrics/LineLength
      end
      example Doxxer.example_for(User)
      def create
        @user = User.new(user_params)

        authorize(@user)

        if @user.save
          @user.skills = Skill.where(id: user_params[:skill_ids])
          @user.languages = Language.where(id: user_params[:language_ids])

          UserWelcomeNotifier.call(user: @user)

          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      api :PATCH, '/users/', 'Update new user'
      description 'Updates and returns the updated user if the user is allowed to.'
      error code: 400, desc: 'Bad request'
      error code: 422, desc: 'Unprocessable entity'
      error code: 401, desc: 'Unauthorized'
      param :user, Hash, desc: 'User attributes', required: true do
        param :name, String, desc: 'Name'
        param :description, String, desc: 'Description'
        param :email, String, desc: 'Email'
        param :phone, String, desc: 'Phone'
        param :street, String, desc: 'Street'
        param :zip, String, desc: 'Zip code'
        param :language_id, Integer, desc: 'Primary language id for user'
      end
      example Doxxer.example_for(User)
      def update
        authorize(@user)

        if @user.update(user_params)
          render json: @user, status: :ok
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/users/:id', 'Delete user'
      description 'Deletes user user if the user is allowed to.'
      error code: 401, desc: 'Unauthorized'
      def destroy
        authorize(@user)

        @user.reset!
        head :no_content
      end

      api :GET, '/users/:id/matching_jobs', 'Show matching jobs for user'
      description 'Returns the matching jobs for user if the user is allowed to.'
      error code: 401, desc: 'Unauthorized'
      def matching_jobs
        authorize(@user)

        render json: Job.matches_user(@user)
      end

      api :GET, 'users/:id/jobs', 'Shows all jobs associated with user'
      # rubocop:disable Metrics/LineLength
      description 'Returns the all jobs where the user is the owner or applicant user if the user is allowed to.'
      # rubocop:enable Metrics/LineLength
      error code: 401, desc: 'Unauthorized'
      def jobs
        authorize(@user)

        @jobs = Queries::UserJobsFinder.new(current_user).perform

        render json: @jobs, status: :ok
      end

      private

      def set_user
        @user = User.find(params[:user_id])
      end

      def user_params
        whitelist = [
          :name, :email, :phone, :description, :street, :zip, :language_id,
          :password, skill_ids: [], language_ids: []
        ]
        jsonapi_params.permit(*whitelist)
      end

      def allowed_includes
        whitelist = %w(languages skills jobs)
        include_params.permit(whitelist)
      end
    end
  end
end
