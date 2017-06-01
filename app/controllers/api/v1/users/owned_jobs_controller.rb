# frozen_string_literal: true

module Api
  module V1
    module Users
      class OwnedJobsController < BaseController
        before_action :set_user

        after_action :verify_authorized, except: %i(index)

        ALLOWED_INCLUDES = %w(owner company language category hourly_pay job_users job_users.user job_users.user.user_images).freeze # rubocop:disable Metrics/LineLength

        api :GET, '/users/:user_id/owned-jobs', 'Shows all jobs that the user owns'
        description 'Returns the all the jobs a user owns if the user is allowed.'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self, Index::JobsIndex)
        example Doxxer.read_example(Job, plural: true)
        def index
          authorize_index(@user)

          job_scope = policy_scope(Job).where(owner: @user)

          jobs_index = Index::JobsIndex.new(self)
          @jobs = jobs_index.jobs(job_scope)

          api_render(@jobs, total: jobs_index.count)
        end

        private

        def set_user
          @user = User.find(params[:user_id])
        end

        def authorize_index(user)
          raise Pundit::NotAuthorizedError unless policy(user).owned_jobs?
        end
      end
    end
  end
end
