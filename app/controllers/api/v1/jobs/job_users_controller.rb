# frozen_string_literal: true
module Api
  module V1
    module Jobs
      class JobUsersController < BaseController
        before_action :require_user
        before_action :set_job
        before_action :set_job_user, only: [:show, :update, :destroy]
        before_action :set_user, only: [:show, :update, :destroy]

        resource_description do
          resource_id 'job_users'
          short 'API for managing job users'
          name 'Job users'
          # rubocop:disable Metrics/LineLength
          description "
            Job users is the relationship between a job and a user.

            A typical flow would be something like this:

            1. To apply for a job a user creates a job user
            2. The owner accepts the user with `POST /jobs/:id/users/:job_user_id/acceptances`
            3. The user then confirms that they will perform the job by setting `POST /jobs/:id/users/:job_user_id/confirmations`
                * It has be be done before `will-perform-confirmation-by` (date-time), if not `accepted` will be set to false automatically.
            4. The user verifies the that the job has been performed with `POST /jobs/:id/users/:job_user_id/performed`
            5. The owner then creates an invoice to pay the user with `POST /jobs/:id/users/:job_user_id/invoices`

            __States__

            * If `accepted` is true then the company has offered job to the user
            * If `accepted` and `will_perform` is true then the job is confirmed from both parties
            * If `performed` is true then the user has confirmed that the job has been performed and that they expect to be paid
          "
          # rubocop:enable Metrics/LineLength
          formats [:json]
          api_versions '1.0'
        end

        ALLOWED_INCLUDES = %w(job job.hourly_pay user user.user_images user.system_language user.language user.languages).freeze # rubocop:disable Metrics/LineLength

        api :GET, '/jobs/:job_id/users', 'Show job users'
        description 'Returns list of job users if the user is allowed.'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self, Index::JobUsersIndex)
        example Doxxer.read_example(JobUser, plural: true)
        def index
          authorize(JobUser)

          job_users_index = Index::JobUsersIndex.new(self)
          job_users_scope = job_users_index_scope(policy_scope(@job.job_users))

          @job_users = job_users_index.job_users(job_users_scope)

          api_render(@job_users, total: job_users_index.count)
        end

        api :GET, '/jobs/:job_id/users/:job_user_id', 'Show job user'
        description 'Returns user.'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self)
        example Doxxer.read_example(JobUser)
        def show
          authorize(JobUser)

          api_render(@job_user)
        end

        api :POST, '/jobs/:job_id/users/', 'Create new job user'
        description 'Creates and returns new job user if the user is allowed.'
        error code: 400, desc: 'Bad request'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        # rubocop:disable Metrics/LineLength
        ApipieDocHelper.params(self)
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Job user attributes', required: true do
            param :user_id, Integer, desc: 'User id of the applicant', required: true
            param :apply_message, String, desc: 'Apply message'
            param :language_id, Integer, desc: 'Language id of the text content (required if apply message is present)'
          end
        end
        # rubocop:enable Metrics/LineLength
        example Doxxer.read_example(JobUser, method: :create)
        def create
          authorize(JobUser)

          user_id = jsonapi_params[:user_id].to_i
          if user_id.zero?
            user = current_user
            ActiveSupport::Deprecation.warn('Not explicitly setting the user id as part of the payload has been deprecated please set a user id.') # rubocop:disable Metrics/LineLength
          elsif user_id == current_user.id
            user = current_user
          elsif current_user.admin?
            user = User.find_by(id: user_id)
          else
            errors = JsonApiErrors.new
            message = I18n.t('errors.job_user.forbidden_applicant_user')
            errors.add(attribute: :user, status: 403, detail: message)

            render json: errors, status: :forbidden
            return
          end

          @job_user = CreateJobApplicationService.call(
            job: @job,
            user: user,
            attributes: job_user_attributes,
            job_owner: @job.owner
          )

          if @job_user.valid?
            api_render(@job_user, status: :created)
          else
            api_render_errors(@job_user)
          end
        end

        api :PATCH, '/jobs/:job_id/users/:job_user_id', '_DEPRECATED_: Update job user'
        description 'Updates a job user if the user is allowed.'
        error code: 400, desc: 'Bad request'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        ApipieDocHelper.params(self)
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Job user attributes', required: true do
            param :accepted, [true], desc: '_DEPRECATED_: User accepted for job'
            param :will_perform, [true], desc: '_DEPRECATED_: User will perform job'
            param :performed, [true], desc: '_DEPRECATED_: Job has been performed by user'
          end
        end
        example Doxxer.read_example(JobUser, method: :update)
        def update
          ActiveSupport::Deprecation.warn('This route has been deprecated.')
          authorize(@job_user)

          @job_user.assign_attributes(job_user_attributes)

          # The event name needs to be set before save, otherwise it can't
          # determine what has changed
          set_event_name(@job_user)

          if @job_user.save
            update_notifier_klass.call(job_user: @job_user, owner: @job.owner)

            on_event(:will_perform) do
              @job.fill_position!
              # Frilans Finans wants invoices to be pre-reported
              FrilansFinansInvoice.create!(job_user: @job_user)
            end

            api_render(@job_user)
          else
            api_render_errors(@job_user)
          end
        end

        api :DELETE, '/jobs/:job_id/users/:job_user_id', 'Delete user user'
        description 'Deletes job user if the user is allowed. It can __not__ be removed if `#will_perform` is true.' # rubocop:disable Metrics/LineLength
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        def destroy
          authorize(@job_user)

          response = WithdrawJobApplicationService.call(
            job_user: @job_user, job_owner: @job.owner
          )
          if response.errors
            render json: response.errors, status: :unprocessable_entity
          else
            head :no_content
          end
        end

        private

        def set_job
          @job = policy_scope(Job).find(params[:job_id])
        end

        def set_user
          @user = @job_user.user
        end

        def set_job_user
          @job_user = @job.job_users.find(params[:job_user_id])
        end

        def job_user_attributes
          @job_user_attributes ||= begin
            attributes = policy(@job_user || JobUser.new).permitted_attributes
            jsonapi_params.permit(attributes)
          end
        end

        def pundit_user
          JobUserPolicy::Context.new(current_user, @job, @user)
        end

        # NOTE: #set_event_name must have been called before this method
        def update_notifier_klass
          case event_name
          when :accepted then ApplicantAcceptedNotifier
          when :will_perform then ApplicantWillPerformNotifier
          when :performed then NilNotifier # JobUserPerformedNotifier
          else
            NilNotifier
          end
        end

        # NOTE: #set_event_name must have been called before this method
        def event_name
          @_event_name
        end

        # NOTE: #set_event_name must have been called before this method
        def on_event(name)
          return unless event_name == name

          yield
        end

        def set_event_name(job_user)
          @_event_name ||= begin
            if job_user.send_accepted_notice?
              message = [
                'Setting JobUser#accepted using PATCH /jobs/:id/users',
                'is deprecated, please use POST /jobs/:id/users/acceptances instead'
              ].join(' ')
              ActiveSupport::Deprecation.warn(message)
              :accepted
            elsif job_user.send_will_perform_notice?
              message = [
                'Setting JobUser#will_perform using PATCH /jobs/:id/users',
                'is deprecated, please use POST /jobs/:id/users/confirmations instead'
              ].join(' ')
              ActiveSupport::Deprecation.warn(message)
              :will_perform
            elsif job_user.send_performed_notice?
              message = [
                'Setting JobUser#performed using PATCH /jobs/:id/users',
                'is deprecated, please use POST /jobs/:id/users/performed instead'
              ].join(' ')
              ActiveSupport::Deprecation.warn(message)
              :performed
            else
              :nothing
            end
          end
        end

        def job_users_index_scope(base_scope)
          base_scope = if included_resource?(:job)
                         base_scope.includes(job: :job_users)
                       else
                         base_scope.includes(:job)
                       end

          if included_resource?(:user) || included_resource?(:'user.user_images')
            user_includes = [:owned_jobs, :user_images, :chats]
            base_scope = base_scope.includes(user: user_includes)
          end

          if included_resource?(:'user.user_images')
            user_includes = [:language, :languages, :company]
            base_scope = base_scope.includes(user: user_includes)
          end

          base_scope
        end
      end
    end
  end
end
