# frozen_string_literal: true
module Index
  class JobUsersIndex < BaseIndex
    SORTABLE_FIELDS = %i(created_at updated_at).freeze
    ALLOWED_FILTERS = %i(accepted will_perform performed job_id).freeze

    def job_users(scope = JobUser)
      @job_users ||= begin
        include_scopes = [:invoice]
        include_scopes << user_include_scopes

        prepare_records(scope.with_translations.includes(*include_scopes))
      end
    end
  end
end
