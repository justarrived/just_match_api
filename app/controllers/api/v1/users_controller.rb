# frozen_string_literal: true
module Api
  module V1
    class UsersController < BaseController
      SET_USER_ACTIONS = [:show, :edit, :update, :destroy, :matching_jobs, :jobs].freeze
      before_action :set_user, only: SET_USER_ACTIONS

      resource_description do
        short 'API for managing users'
        name 'Users'
        description 'There are currently three types of user roles: `candidate`, `company` and `admin`.' # rubocop:disable Metrics/LineLength
        formats [:json]
        api_versions '1.0'
      end

      ALLOWED_INCLUDES = %w(user_languages user_languages.language language languages company user_images).freeze # rubocop:disable Metrics/LineLength

      api :GET, '/users', 'List users'
      description 'Returns a list of users if the user is allowed.'
      ApipieDocHelper.params(self, Index::UsersIndex)
      example Doxxer.read_example(User, plural: true)
      def index
        authorize(User)

        users_index = Index::UsersIndex.new(self)
        @users = users_index.users

        api_render(@users, total: users_index.count)
      end

      api :GET, '/users/:id', 'Show user'
      description 'Returns user is allowed to.'
      error code: 404, desc: 'Not found'
      ApipieDocHelper.params(self)
      example Doxxer.read_example(User, meta: { average_score: 4.3, total_ratings_count: 5 }) # rubocop:disable Metrics/LineLength
      def show
        authorize(@user)

        meta = {
          average_score: @user.average_score,
          total_ratings_count: @user.received_ratings_count
        }
        api_render(@user, meta: meta)
      end

      api :POST, '/users/', 'Create new user'
      description 'Creates and returns a new user.'
      error code: 400, desc: 'Bad request'
      error code: 422, desc: 'Unprocessable entity'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'User attributes', required: true do
          # rubocop:disable Metrics/LineLength
          param :skill_ids, Array, of: 'Skill IDs', desc: 'List of skill ids'
          param :first_name, String, desc: 'First name', required: true
          param :last_name, String, desc: 'Last name', required: true
          param :description, String, desc: 'Description'
          param :job_experience, String, desc: 'Job experience'
          param :education, String, desc: 'Education'
          param :competence_text, String, desc: 'Competences'
          param :email, String, desc: 'Email', required: true
          param :phone, String, desc: 'Phone', required: true
          param :street, String, desc: 'Street'
          param :zip, String, desc: 'Zip code'
          param :ssn, String, desc: 'Social Security Number (10 characters)'
          param :ignored_notifications, Array, of: 'ignored notifications', desc: "List of ignored notifications. Any of: #{User::NOTIFICATIONS.map { |n| "`#{n}`" }.join(', ')}"
          param :company_id, Integer, desc: 'Company id for user'
          param :language_id, Integer, desc: 'Primary language id for user', required: true
          param :language_ids, Array, of: Hash, desc: 'Languages that the user knows', required: true do
            param :id, Integer, desc: 'Language id', required: true
            param :proficiency, UserLanguage::PROFICIENCY_RANGE.to_a, desc: 'Language proficiency'
          end
          param :user_image_one_time_tokens, Array, of: 'UserImage one time tokens', desc: 'User image one time tokens'
          param :current_status, User::STATUSES.keys, desc: 'Current status'
          param :at_und, User::AT_UND.keys, desc: 'AT-UND status'
          param :arrived_at, String, desc: 'Arrived at date'
          param :country_of_origin, String, desc: 'Country of origin (alpha-2 code)'
          # rubocop:enable Metrics/LineLength
        end
      end
      example Doxxer.read_example(User, method: :create)
      def create
        @user = User.new(user_params)
        @user.email = @user.email&.strip

        authorize(@user)

        if @user.save
          login_user(@user)

          @user.set_translation(user_params).tap do |result|
            EnqueueCheapTranslation.call(result)
          end

          @user.skills = Skill.where(id: user_params[:skill_ids])

          image_tokens = jsonapi_params[:user_image_one_time_tokens]

          deprecated_param_value = jsonapi_params[:user_image_one_time_token]
          if deprecated_param_value.blank?
            @user.set_images_by_tokens = image_tokens unless image_tokens.blank?
          else
            message = 'The param "user_image_one_time_token" has been deprecated please use "user_image_one_time_tokens" instead' # rubocop:disable Metrics/LineLength
            ActiveSupport::Deprecation.warn(message)
            @user.profile_image_token = deprecated_param_value
          end

          language_ids = jsonapi_params[:language_ids]
          SetUserLanguagesService.call(user: @user, language_ids_param: language_ids)
          UserWelcomeNotifier.call(user: @user)

          api_render(@user, status: :created)
        else
          api_render_errors(@user)
        end
      end

      api :PATCH, '/users/:id', 'Update new user'
      description 'Updates and returns the updated user if the user is allowed.'
      error code: 400, desc: 'Bad request'
      error code: 422, desc: 'Unprocessable entity'
      error code: 401, desc: 'Unauthorized'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'User attributes', required: true do
          # rubocop:disable Metrics/LineLength
          param :first_name, String, desc: 'First name'
          param :last_name, String, desc: 'Last name'
          param :description, String, desc: 'Description'
          param :job_experience, String, desc: 'Job experience'
          param :education, String, desc: 'Education'
          param :competence_text, String, desc: 'Competences'
          param :email, String, desc: 'Email'
          param :phone, String, desc: 'Phone'
          param :street, String, desc: 'Street'
          param :zip, String, desc: 'Zip code'
          param :ssn, String, desc: 'Social Security Number (10 characters)'
          param :ignored_notifications, Array, of: 'ignored notifications', desc: "List of ignored notifications. Any of: #{User::NOTIFICATIONS.map { |n| "`#{n}`" }.join(', ')}"
          param :language_id, Integer, desc: 'Primary language id for user'
          param :language_ids, Array, of: Hash, desc: 'Languages that the user knows (if specified this will completely replace the users languages)' do
            param :id, Integer, desc: 'Language id', required: true
            param :proficiency, UserLanguage::PROFICIENCY_RANGE.to_a, desc: 'Language proficiency'
          end
          param :company_id, Integer, desc: 'Company id for user'
          param :user_image_one_time_token, String, desc: 'User image one time token'
          param :current_status, User::STATUSES.keys, desc: 'Current status'
          param :at_und, User::AT_UND.keys, desc: 'AT-UND status'
          param :arrived_at, String, desc: 'Arrived at date'
          param :country_of_origin, String, desc: 'Country of origin'
          # rubocop:enable Metrics/LineLength
        end
      end
      example Doxxer.read_example(User, method: :update)
      def update
        authorize(@user)

        if @user.update(user_params)
          @user.set_translation(user_params).tap do |result|
            EnqueueCheapTranslation.call(result)
          end

          @user.reload

          language_ids = jsonapi_params[:language_ids]
          SetUserLanguagesService.call(user: @user, language_ids_param: language_ids)

          @user.profile_image_token = jsonapi_params[:user_image_one_time_token]

          api_render(@user)
        else
          api_render_errors(@user)
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

        render json: Job.uncancelled.matches_user(@user)
      end

      api :GET, '/users/notifications', 'Show all possible user notifications'
      description 'Returns a list of all possible user notifications.'
      example JSON.pretty_generate(UserNotificationsSerializer.serializeble_resource(key_transform: :underscore).to_h) # rubocop:disable Metrics/LineLength
      def notifications
        authorize(User)

        resource = UserNotificationsSerializer.serializeble_resource(key_transform: key_transform_header) # rubocop:disable Metrics/LineLength

        render json: resource
      end

      api :GET, '/users/statuses', 'Show all possible user statuses'
      description 'Returns a list of all possible user statuses.'
      example JSON.pretty_generate(UserStatusesSerializer.serializeble_resource(key_transform: :underscore).to_h) # rubocop:disable Metrics/LineLength
      def statuses
        authorize(User)

        resource = UserStatusesSerializer.serializeble_resource(key_transform: key_transform_header) # rubocop:disable Metrics/LineLength

        render json: resource
      end

      private

      def set_user
        @user = User.find(params[:user_id])
      end

      def user_params
        whitelist = [
          :first_name, :last_name, :email, :phone, :description, :job_experience,
          :education, :ssn, :street, :zip, :language_id, :password, :company_id,
          :competence_text, :current_status, :at_und, :arrived_at, :country_of_origin,
          ignored_notifications: [], skill_ids: []
        ]
        jsonapi_params.permit(*whitelist)
      end
    end
  end
end
