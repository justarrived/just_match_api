# frozen_string_literal: true
module Api
  module V1
    module Users
      class UserJobsController < BaseController
        before_action :set_user

        after_action :verify_authorized, except: %i(index)

        ALLOWED_INCLUDES = %w(job user).freeze

        api :GET, '/users/:user_id/jobs', 'Shows all job users associated with user'
        # rubocop:disable Metrics/LineLength
        description 'Returns the all job users where the user is the owner or applicant if the user is allowed.'
        # rubocop:enable Metrics/LineLength
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self, Index::JobUsersIndex)
        example Doxxer.read_example(JobUser, plural: true)
        def index
          authorize_index(@user)

          job_user_scope = JobUser.where(user: @user)

          job_users_index = Index::JobUsersIndex.new(self)
          @job_users = job_users_index.job_users(job_user_scope)

          api_render(@job_users, total: job_users_index.count)
        end

        private

        def set_user
          @user = User.find(params[:user_id])
        end

        def authorize_index(user)
          raise Pundit::NotAuthorizedError unless policy(user).jobs?
        end
      end
    end
  end
end
