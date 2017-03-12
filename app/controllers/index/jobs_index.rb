# frozen_string_literal: true
module Index
  class JobsIndex < BaseIndex
    FILTER_MATCH_TYPES = {
      name: { translated: :contains },
      description: { translated: :contains }
    }.freeze
    TRANSFORMABLE_FILTERS = TRANSFORMABLE_FILTERS.merge(job_date: :date_range).freeze
    ALLOWED_FILTERS = %i(
      id name description hours created_at job_date verified filled featured
      staffing_job direct_recruitment_job job_user.user_id
    ).freeze
    SORTABLE_FIELDS = %i(
      hours job_date name verified filled featured created_at updated_at staffing_job
      direct_recruitment_job
    ).freeze

    def jobs(scope = Job)
      @jobs ||= begin
        include_scopes = [
          :language, :company, :category, :hourly_pay, :job_skills, :job_languages
        ]

        include_scopes << user_include_scopes(user_key: :owner)

        include_scopes << :job_users if current_user.company? || current_user.admin?

        scope = filter_job_user_jobs(scope, filter_params[:'job_user.user_id'])

        prepare_records(scope.with_translations.includes(*include_scopes))
      end
    end

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
