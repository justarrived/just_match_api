# frozen_string_literal: true
module Api
  module V1
    module Jobs
      class ConfirmationsController < BaseController
        resource_description do
          short 'API for job confirmations'
          name 'Job confirmations'
          description ''
          formats [:json]
          api_versions '1.0'
        end

        before_action :require_user
        before_action :set_job
        before_action :set_job_user

        after_action :verify_authorized, except: %i(create)

        api :POST, '/jobs/:job_id/users/:job_user_id/confirmations', 'Confirm job'
        description 'Confirm performance of a job.'
        error code: 400, desc: 'Bad request'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        ApipieDocHelper.params(self)
        example Doxxer.read_example(JobUser, method: :update)
        def create
          @job_user = SignJobUserService.call(job_user: @job_user, job_owner: @job.owner)
          if @job_user.valid?
            api_render(@job_user)
          else
            api_render_errors(@job_user)
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

        def authorize_create(job_user)
          policy = JobUserPolicy.new(current_user, job_user)

          unless policy.permitted_attributes.include?(:will_perform)
            raise Pundit::NotAuthorizedError
          end
        end
      end
    end
  end
end
