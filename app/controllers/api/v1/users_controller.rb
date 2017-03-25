# frozen_string_literal: true
require 'email_suggestion'

module Api
  module V1
    class UsersController < BaseController
      SET_USER_ACTIONS = [:show, :edit, :update, :destroy, :matching_jobs, :jobs].freeze
      before_action :set_user, only: SET_USER_ACTIONS

      before_action :require_promo_code, except: [:statuses]

      resource_description do
        short 'API for managing users'
        name 'Users'
        description 'There are currently three types of user roles: `candidate`, `company` and `admin`.' # rubocop:disable Metrics/LineLength
        formats [:json]
        api_versions '1.0'
      end

      ALLOWED_INCLUDES = %w(
        user_languages user_languages.language language languages company user_images
        user_skills skills user_skills.skill user_documents user_documents.document
      ).freeze

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
          param :first_name, String, desc: 'First name', required: true
          param :last_name, String, desc: 'Last name', required: true
          param :consent, [true], desc: 'Terms of agreement consent', required: true
          param :description, String, desc: 'Description'
          param :job_experience, String, desc: 'Job experience'
          param :education, String, desc: 'Education'
          param :competence_text, String, desc: 'Competences'
          param :email, String, desc: 'Email', required: true
          param :phone, String, desc: 'Phone'
          param :password, String, desc: 'Password'
          param :street, String, desc: 'Street'
          param :zip, String, desc: 'Zip code'
          param :city, String, desc: 'City'
          param :ssn, String, desc: 'Social Security Number (10 characters)'
          param :ignored_notifications, Array, of: 'ignored notifications', desc: "List of ignored notifications. Any of: #{User::NOTIFICATIONS.map { |n| "`#{n}`" }.join(', ')}"
          param :company_id, Integer, desc: 'Company id for user'
          param :system_language_id, Integer, desc: 'System language id for user (SMS/emails etc will be sent in this language)', required: true
          param :language_id, Integer, desc: 'Language id for the text fields'
          param :language_ids, Array, of: Hash, desc: 'Languages that the user knows', required: true do
            param :id, Integer, desc: 'Language id', required: true
            param :proficiency, UserLanguage::PROFICIENCY_RANGE.to_a, desc: 'Language proficiency'
          end
          param :skill_ids, Array, of: Hash, desc: 'List of skill ids' do
            param :id, Integer, desc: 'Skill id', required: true
            param :proficiency, UserSkill::PROFICIENCY_RANGE.to_a, desc: 'Skill proficiency'
          end
          param :interest_ids, Array, of: Hash, desc: 'List of interest ids' do
            param :id, Integer, desc: 'Level id', required: true
            param :proficiency, UserInterest::LEVEL_RANGE.to_a, desc: 'Interest level'
          end
          param :user_image_one_time_tokens, Array, of: 'UserImage one time tokens', desc: 'User image one time tokens'
          param :current_status, User::STATUSES.keys, desc: 'Current status'
          param :at_und, User::AT_UND.keys, desc: 'AT-UND status'
          param :gender, User::GENDER.keys, desc: 'Gender'
          param :arrived_at, String, desc: 'Arrived at date'
          param :country_of_origin, String, desc: 'Country of origin (alpha-2 code)'
          param :skype_username, String, desc: 'Skype username'
          param :account_clearing_number, String, desc: 'User account clearing number'
          param :account_number, String, desc: 'User account number'
          param :next_of_kin_name, String, desc: 'Next of kin name'
          param :next_of_kin_phone, String, desc: 'Next of kin phone'
          param :arbetsformedlingen_registered_at, Date, desc: 'Arbetsförmedlingen registered at'
          # rubocop:enable Metrics/LineLength
        end
      end
      example Doxxer.read_example(User, method: :create)
      def create
        @user = User.new(user_params)
        @user.password = jsonapi_params[:password]
        terms_consent = [true, 'true'].include?(jsonapi_params[:consent])
        language_defined = true

        if jsonapi_params[:system_language_id].blank? && jsonapi_params[:language_id].blank? # rubocop:disable Metrics/LineLength
          language_defined = false
        elsif jsonapi_params[:system_language_id].blank?
          ActiveSupport::Deprecation.warn('Setting #system_language from #language is deprecated and will be removed soon.') # rubocop:disable Metrics/LineLength
          @user.system_language_id = jsonapi_params[:language_id]
        end

        authorize(@user)
        @user.validate

        if terms_consent && language_defined && @user.valid?
          @user.save
          login_user(@user)

          @user.set_translation(user_params).tap do |result|
            ProcessTranslationJob.perform_later(translation: result.translation)
          end

          image_tokens = jsonapi_params[:user_image_one_time_tokens]

          deprecated_param_value = jsonapi_params[:user_image_one_time_token]
          if deprecated_param_value.blank?
            @user.set_images_by_tokens = image_tokens unless image_tokens.blank?
          else
            message = 'The param "user_image_one_time_token" has been deprecated please use "user_image_one_time_tokens" instead' # rubocop:disable Metrics/LineLength
            ActiveSupport::Deprecation.warn(message)
            @user.profile_image_token = deprecated_param_value
          end

          SetUserTraitsService.call(
            user: @user,
            language_ids_param: jsonapi_params[:language_ids],
            skill_ids_param: jsonapi_params[:skill_ids],
            interest_ids_param: jsonapi_params[:interest_ids]
          )

          UserWelcomeNotifier.call(user: @user) if @user.candidate?
          sync_ff_user(@user)

          api_render(@user, status: :created)
        else
          unless terms_consent
            consent_error = I18n.t('errors.user.must_consent_to_terms_of_agreement')
            @user.errors.add(:consent, consent_error)
          end

          unless language_defined
            # When the clients have moved to using #system_language this can be removed
            @user.errors.add(:language, I18n.t('errors.messages.blank'))
          end

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
          param :city, String, desc: 'City'
          param :ssn, String, desc: 'Social Security Number (10 characters)'
          param :ignored_notifications, Array, of: 'ignored notifications', desc: "List of ignored notifications. Any of: #{User::NOTIFICATIONS.map { |n| "`#{n}`" }.join(', ')}"
          param :system_language_id, Integer, desc: 'System language id for user (SMS/emails etc will be sent in this language)'
          param :language_id, Integer, desc: 'Language id for the text fields'
          param :language_ids, Array, of: Hash, desc: 'Languages that the user knows (if specified this will completely replace the users languages)' do
            param :id, Integer, desc: 'Language id', required: true
            param :proficiency, UserLanguage::PROFICIENCY_RANGE.to_a, desc: 'Language proficiency'
          end
          param :skill_ids, Array, of: Hash, desc: 'List of skill ids' do
            param :id, Integer, desc: 'Skill id', required: true
            param :proficiency, UserSkill::PROFICIENCY_RANGE.to_a, desc: 'Skill proficiency'
          end
          param :interest_ids, Array, of: Hash, desc: 'List of interest ids' do
            param :id, Integer, desc: 'Level id', required: true
            param :proficiency, UserInterest::LEVEL_RANGE.to_a, desc: 'Interest level'
          end
          param :company_id, Integer, desc: 'Company id for user'
          param :user_image_one_time_token, String, desc: '_DEPRECATED_ User image one time token'
          param :current_status, User::STATUSES.keys, desc: 'Current status'
          param :at_und, User::AT_UND.keys, desc: 'AT-UND status'
          param :gender, User::GENDER.keys, desc: 'Gender'
          param :arrived_at, String, desc: 'Arrived at date'
          param :country_of_origin, String, desc: 'Country of origin'
          param :skype_username, String, desc: 'Skype username'
          param :account_clearing_number, String, desc: 'User account clearing number'
          param :account_number, String, desc: 'User account number'
          param :next_of_kin_name, String, desc: 'Next of kin name'
          param :next_of_kin_phone, String, desc: 'Next of kin phone'
          param :arbetsformedlingen_registered_at, Date, desc: 'Arbetsförmedlingen registered at'
          # rubocop:enable Metrics/LineLength
        end
      end
      example Doxxer.read_example(User, method: :update)
      def update
        authorize(@user)

        unless jsonapi_params[:language_id].blank?
          ActiveSupport::Deprecation.warn('Setting #system_language from #language is deprecated and will be removed soon.') # rubocop:disable Metrics/LineLength
          # NOTE: This is just temporary until the client app is updated
          @user.system_language_id = jsonapi_params[:language_id]
        end

        if @user.update(user_params)
          @user.set_translation(user_params).tap do |result|
            ProcessTranslationJob.perform_later(translation: result.translation)
          end

          @user.reload

          SetUserTraitsService.call(
            user: @user,
            language_ids_param: jsonapi_params[:language_ids],
            skill_ids_param: jsonapi_params[:skill_ids],
            interest_ids_param: jsonapi_params[:interest_ids]
          )

          @user.profile_image_token = jsonapi_params[:user_image_one_time_token]
          sync_ff_user(@user)

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

      api :POST, '/users/images/', 'User images'
      description 'Creates a user image'
      error code: 422, desc: 'Unprocessable entity'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'User image attributes', required: true do
          param :category, UserImage::CATEGORIES.keys, desc: 'User image category', required: true # rubocop:disable Metrics/LineLength
          param :image, String, desc: 'Image (data uri, data/image)', required: true
        end
      end
      example Doxxer.read_example(UserImage, method: :create)
      def images
        authorize(UserImage)

        if params[:image]
          @user_image = UserImage.new(image: params[:image])
          ActiveSupport::Deprecation.warn('Using multipart to upload an image is deprecated and will soon be removed please consult the documentation at api.justarrived.se to see the new method.') # rubocop:disable Metrics/LineLength
        else
          data_image = DataUriImage.new(user_image_params[:image])
          unless data_image.valid?
            respond_with_invalid_image_content_type
            return
          end

          @user_image = UserImage.new(image: data_image.image)
        end

        @user_image.category = if user_image_params[:category].blank?
                                 ActiveSupport::Deprecation.warn('Not setting an image category has been deprecated, please provide a "category" param.') # rubocop:disable Metrics/LineLength
                                 @user_image.default_category
                               else
                                 user_image_params[:category]
                               end

        if @user_image.save
          api_render(@user_image, status: :created)
        else
          api_render_errors(@user_image)
        end
      end

      api :GET, '/users/:id/matching-jobs', 'Show matching jobs for user'
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

      api :GET, '/users/genders', 'Show all possible user genders'
      description 'Returns a list of all possible user genders.'
      example JSON.pretty_generate(UserGendersSerializer.serializeble_resource.to_h)
      def genders
        authorize(User)

        resource = UserGendersSerializer.serializeble_resource # rubocop:disable Metrics/LineLength

        render json: resource
      end

      private

      def respond_with_invalid_image_content_type
        errors = JsonApiErrors.new
        message = I18n.t('errors.user.invalid_image_content_type')
        errors.add(status: 422, detail: message)

        render json: errors, status: :unprocessable_entity
      end

      def sync_ff_user(user)
        if AppConfig.frilans_finans_active?
          SyncFrilansFinansUserJob.perform_later(user: user)
        end
      end

      def set_user
        @user = User.find(params[:user_id])
      end

      def user_image_params
        jsonapi_params.permit(:category, :image)
      end

      def user_params
        whitelist = [
          :first_name, :last_name, :email, :phone, :description, :job_experience,
          :education, :ssn, :street, :city, :zip, :language_id, :company_id,
          :competence_text, :current_status, :at_und, :arrived_at, :country_of_origin,
          :account_clearing_number, :account_number, :skype_username, :gender,
          :system_language_id, ignored_notifications: []
        ]
        jsonapi_params.permit(*whitelist)
      end
    end
  end
end
