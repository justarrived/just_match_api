# frozen_string_literal: true
module Index
  class JobsIndex < BaseIndex
    TRANSFORMABLE_FILTERS = TRANSFORMABLE_FILTERS.merge(job_date: :date_range).freeze
    ALLOWED_FILTERS = %i(id hours created_at job_date verified filled job_user.user_id).freeze
    SORTABLE_FIELDS = %i(hours job_date name verified created_at updated_at).freeze

    def jobs(scope = Job)
      @jobs ||= begin
        include_scopes = [:language, :company, :category, :hourly_pay]
        include_scopes << user_include_scopes(user_key: :owner)

        scope = filter_job_user_jobs(scope, filter_params[:'job_user.user_id'])

        prepare_records(scope.includes(*include_scopes))
      end
    end

    # NOTE: This method doesn't have any automated tests :( yet...
    def filter_job_user_jobs(scope, filter_user_id)
      return scope if filter_user_id.blank? || current_user.not_persisted?

      current_user_id = current_user.id.to_s
      user_id = filter_user_id.delete('-')

      # Only allow the user to filter its own job users (avoids info disclosure..)
      return scope unless current_user_id == user_id || current_user.admin?

      # If filter starts with '-', only return non-matching records
      return scope.no_applied_jobs(user_id) if filter_user_id.start_with?('-')

      scope.applied_jobs(user_id)
    end
  end
end
