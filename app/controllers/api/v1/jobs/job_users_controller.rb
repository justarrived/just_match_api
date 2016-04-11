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
          description '
            Job users is the relationship between a job and a users.
          '
          formats [:json]
          api_versions '1.0'
        end

        ALLOWED_INCLUDES = %w(job user).freeze

        api :GET, '/jobs/:job_id/users', 'Show job users'
        description 'Returns list of job users if the user is allowed.'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self, Index::JobUsersIndex)
        example Doxxer.read_example(JobUser, plural: true)
        def index
          authorize(JobUser)

          job_users_index = Index::JobUsersIndex.new(self)
          @job_users = job_users_index.job_users(@job.job_users)

          api_render(@job_users)
        end

        api :GET, '/jobs/:job_id/users/:id', 'Show job user'
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
        example Doxxer.read_example(JobUser)
        def create
          authorize(JobUser)

          @job_user = JobUser.new
          @job_user.user = current_user
          @job_user.job = @job

          if @job_user.save
            NewApplicantNotifier.call(job_user: @job_user)
            api_render(@job_user, status: :created)
          else
            respond_with_errors(@job_user)
          end
        end

        api :PATCH, '/jobs/:job_id/users/:id', 'Update job user'
        description 'Updates a job user if the user is allowed.'
        error code: 400, desc: 'Bad request'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Job user attributes', required: true do
            param :accepted, [true], desc: 'User accepted for job'
            param :will_perform, [true], desc: 'User will perform job'
            param :performed, [true], desc: 'Job has been performed by user'
          end
        end
        example Doxxer.read_example(JobUser)
        def update
          authorize(JobUser)

          @job_user.assign_attributes(permitted_attributes)

          # The notifier klass needs to be fetched before save, otherwise it can't
          # determine whats changed and therefore what notifications to send
          notifier_klass = update_notifier_klass(@job_user)

          if @job_user.save
            notifier_klass.call(job: @job, user: @user)

            api_render(@job_user)
          else
            respond_with_errors(@job_user)
          end
        end

        api :DELETE, '/jobs/:job_id/users/:id', 'Delete user user'
        description 'Deletes job user if the user is allowed.'
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
              AcceptedApplicantWithdrawnNotifier.call(job: @job, user: @user)
            end

            @job_user.destroy
            head :no_content
          end
        end

        private

        def set_job
          @job = Job.find(params[:job_id])
        end

        def set_user
          @user = @job_user.user
        end

        def set_job_user
          @job_user = @job.job_users.find(params[:id])
        end

        def permitted_attributes
          attributes = policy(JobUser.new).permitted_attributes
          jsonapi_params.permit(attributes)
        end

        def pundit_user
          JobUserPolicy::Context.new(current_user, @job, @user)
        end

        def update_notifier_klass(job_user)
          case event_name(job_user)
          when :accepted then ApplicantAcceptedNotifier
          when :will_perform then ApplicantWillPerformNotifier
          when :performed then JobUserPerformedNotifier
          else
            NilNotifier
          end
        end

        def event_name(job_user)
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
      end
    end
  end
end
