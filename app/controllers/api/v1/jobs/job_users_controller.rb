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
            2. The owner accepts the user by setting `accepted` to true
            3. The user then confirms that they will perform the job by setting `will-perform` to true.
                * It has be be done before `will-perform-confirmation-by` (date-time), if not `accepted` will be set to false automatically.
            4. The user verifies the that the job has been performed by setting `performed` to true
            5. The owner then creates an invoice to pay the user
          "
          # rubocop:enable Metrics/LineLength
          formats [:json]
          api_versions '1.0'
        end

        ALLOWED_INCLUDES = %w(job user user.user_images user.language user.languages).freeze # rubocop:disable Metrics/LineLength

        api :GET, '/jobs/:job_id/users', 'Show job users'
        description 'Returns list of job users if the user is allowed.'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self, Index::JobUsersIndex)
        example Doxxer.read_example(JobUser, plural: true)
        def index
          authorize(JobUser)

          job_users_index = Index::JobUsersIndex.new(self)
          job_users_scope = job_users_index_scope(@job.job_users)

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
        example Doxxer.read_example(JobUser, method: :create)
        def create
          authorize(JobUser)

          @job_user = JobUser.new
          @job_user.user = current_user
          @job_user.job = @job

          if @job_user.save
            NewApplicantNotifier.call(job_user: @job_user, owner: @job.owner)
            api_render(@job_user, status: :created)
          else
            respond_with_errors(@job_user)
          end
        end

        api :PATCH, '/jobs/:job_id/users/:job_user_id', 'Update job user'
        description 'Updates a job user if the user is allowed.'
        error code: 400, desc: 'Bad request'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Job user attributes', required: true do
            param :accepted, [true], desc: 'User accepted for job'
            param :'will-perform', [true], desc: 'User will perform job'
            param :performed, [true], desc: 'Job has been performed by user'
          end
        end
        example Doxxer.read_example(JobUser, method: :update)
        def update
          authorize(JobUser)

          @job_user.assign_attributes(permitted_attributes)

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
            respond_with_errors(@job_user)
          end
        end

        api :DELETE, '/jobs/:job_id/users/:job_user_id', 'Delete user user'
        description 'Deletes job user if the user is allowed. It can __not__ be removed if `#will_perform` is true.' # rubocop:disable Metrics/LineLength
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        def destroy
          authorize(JobUser)

          if @job_user.will_perform
            message = I18n.t('errors.job_user.will_perform_true_on_delete')
            @job_user.errors.add(:will_perform, message)
            respond_with_errors(@job_user)
          else
            if @job_user.accepted
              AcceptedApplicantWithdrawnNotifier.call(
                job_user: @job_user,
                owner: @job.owner
              )
            end

            @job_user.destroy
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

        def permitted_attributes
          attributes = policy(JobUser.new).permitted_attributes
          jsonapi_params.permit(attributes)
        end

        def pundit_user
          JobUserPolicy::Context.new(current_user, @job, @user)
        end

        # NOTE: #set_event_name must have been called before this method
        def update_notifier_klass
          case event_name
          when :accepted then ApplicantAcceptedNotifier
          when :will_perform then ApplicantWillPerformNotifier
          when :performed then JobUserPerformedNotifier
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
              :accepted
            elsif job_user.send_will_perform_notice?
              :will_perform
            elsif job_user.send_performed_notice?
              :performed
            else
              :nothing
            end
          end
        end

        def job_users_index_scope(base_scope)
          if included_resource?(:job)
            base_scope = base_scope.includes(job: :job_users)
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
