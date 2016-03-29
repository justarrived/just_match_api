# frozen_string_literal: true
module Api
  module V1
    module Users
      class UserJobsController < BaseController
        before_action :set_user

        after_action :verify_authorized, except: %i(index)

        FILTERABLE = %i(accepted will_perform performed performed_accepted).freeze

        ALLOWED_INCLUDES = %w(owner company language category).freeze

        api :GET, '/users/:user_id/jobs', 'Shows all jobs associated with user'
        # rubocop:disable Metrics/LineLength
        description 'Returns the all jobs where the user is the owner or applicant user if the user is allowed.'
        # rubocop:enable Metrics/LineLength
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self, Index::JobsIndex)
        FILTERABLE.each do |filter|
          param "filter[#{filter}]", String, "Filter resource by *#{filter}*"
        end
        example Doxxer.read_example(Job, plural: true)
        def index
          authorize_index(@user)

          filter_params = FilterParams.filtered_fields(params[:filter], FILTERABLE, {})

          job_scope = Queries::UserJobsFinder.new(
            @user,
            job_user_filters: filter_params
          ).perform

          jobs_index = Index::JobsIndex.new(self)
          @jobs = jobs_index.jobs(job_scope)

          api_render(@jobs)
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
