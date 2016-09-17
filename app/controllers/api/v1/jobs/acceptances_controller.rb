# frozen_string_literal: true
module Api
  module V1
    module Jobs
      class AcceptancesController < BaseController
        resource_description do
          short 'API for job acceptances'
          name 'Job acceptances'
          description ''
          formats [:json]
          api_versions '1.0'
        end

        before_action :require_user
        before_action :set_job
        before_action :set_job_user

        after_action :verify_authorized, except: %i(create)

        api :POST, '/jobs/:job_id/users/:job_user_id/acceptances', 'Accept user for job'
        description 'Accept user for job'
        error code: 400, desc: 'Bad request'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        def create
          @job_user.accepted = true

          if @job_user.save
            ApplicantAcceptedNotifier.call(job_user: @job_user, owner: @job.owner)

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

          unless policy.permitted_attributes.include?(:accepted)
            raise Pundit::NotAuthorizedError
          end
        end
      end
    end
  end
end
