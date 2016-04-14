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

      ALLOWED_INCLUDES = %w(language languages company).freeze

      api :GET, '/users', 'List users'
      description 'Returns a list of users if the user is allowed.'
      ApipieDocHelper.params(self, Index::UsersIndex)
      example Doxxer.read_example(User, plural: true)
      def index
        authorize(User)

        users_index = Index::UsersIndex.new(self)
        @users = users_index.users

        api_render(@users)
      end

      api :GET, '/users/:id', 'Show user'
      description 'Returns user is allowed to.'
      error code: 404, desc: 'Not found'
      ApipieDocHelper.params(self)
      example Doxxer.read_example(User)
      def show
        authorize(@user)

        api_render(@user)
      end

      api :POST, '/users/', 'Create new user'
      description 'Creates and returns a new user.'
      error code: 400, desc: 'Bad request'
      error code: 422, desc: 'Unprocessable entity'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'User attributes', required: true do
          # rubocop:disable Metrics/LineLength
          param :'skill-ids', Array, of: Integer, desc: 'List of skill ids'
          param :'first-name', String, desc: 'First name', required: true
          param :'last-name', String, desc: 'Last name', required: true
          param :description, String, desc: 'Description', required: true
          param :'job-experience', String, desc: 'Job experience'
          param :education, String, desc: 'Education'
          param :email, String, desc: 'Email', required: true
          param :phone, String, desc: 'Phone', required: true
          param :street, String, desc: 'Street', required: true
          param :zip, String, desc: 'Zip code', required: true
          param :ssn, String, desc: 'Social Security Number (10 characters)', required: true
          param :'ignored-notifications', Array, desc: 'List of ignored notifications'
          param :'language-id', Integer, desc: 'Primary language id for user', required: true
          param :'language-ids', Array, of: Integer, desc: 'Language ids of languages that the user knows', required: true
          # rubocop:enable Metrics/LineLength
        end
      end
      example Doxxer.read_example(User)
      def create
        @user = User.new(user_params)

        authorize(@user)

        if @user.save
          login_user(@user)

          @user.skills = Skill.where(id: user_params[:skill_ids])
          @user.languages = Language.where(id: user_params[:language_ids])

          UserWelcomeNotifier.call(user: @user)

          api_render(@user, status: :created)
        else
          respond_with_errors(@user)
        end
      end

      api :PATCH, '/users/', 'Update new user'
      description 'Updates and returns the updated user if the user is allowed.'
      error code: 400, desc: 'Bad request'
      error code: 422, desc: 'Unprocessable entity'
      error code: 401, desc: 'Unauthorized'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'User attributes', required: true do
          param :'first-name', String, desc: 'First name'
          param :'last-name', String, desc: 'Last name'
          param :description, String, desc: 'Description'
          param :'job-experience', String, desc: 'Job experience'
          param :education, String, desc: 'Education'
          param :email, String, desc: 'Email'
          param :phone, String, desc: 'Phone'
          param :street, String, desc: 'Street'
          param :zip, String, desc: 'Zip code'
          param :ssn, String, desc: 'Social Security Number (10 characters)'
          param :'ignored-notifications', Array, desc: 'List of ignored notifications'
          param :'language-id', Integer, desc: 'Primary language id for user'
        end
      end
      example Doxxer.read_example(User)
      def update
        authorize(@user)

        if @user.update(user_params)
          api_render(@user)
        else
          respond_with_errors(@user)
        end
      end

      api :DELETE, '/users/:id', 'Delete user'
      description 'Deletes user user if the user is allowed.'
      error code: 401, desc: 'Unauthorized'
      error code: 404, desc: 'Not found'
      def destroy
        authorize(@user)

        @user.reset!
        head :no_content
      end

      api :GET, '/users/:id/matching_jobs', 'Show matching jobs for user'
      description 'Returns the matching jobs for user if the user is allowed.'
      error code: 401, desc: 'Unauthorized'
      error code: 404, desc: 'Not found'
      def matching_jobs
        authorize(@user)

        render json: Job.matches_user(@user)
      end

      api :GET, '/users/notifications', 'Show all possible user notifications'
      description 'Returns a list of all possible user notifications.'
      def notifications
        authorize(User)

        notifications_data = User::NOTIFICATIONS.each_with_index.map do |name, index|
          # Start with id=1
          user_notification(id: index + 1, name: name)
        end

        render json: { data: notifications_data }
      end

      private

      def set_user
        @user = User.find(params[:user_id])
      end

      def user_params
        whitelist = [
          :first_name, :last_name, :email, :phone, :description, :job_experience,
          :education, :ssn, :street, :zip, :language_id, :password,
          ignored_notifications: [], skill_ids: [], language_ids: []
        ]
        jsonapi_params.permit(*whitelist)
      end

      def user_notification(id:, name:)
        {
          id: id.to_s,
          type: 'user_notifications',
          attributes: {
            name => I18n.t("notifications.#{name}")
          }
        }
      end
    end
  end
end
