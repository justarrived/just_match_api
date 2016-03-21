# frozen_string_literal: true
module Index
  class JobsIndex < BaseIndex
    ALLOWED_INCLUDES = %w(owner company language).freeze
    SORTABLE_FIELDS = %i(hours job_date name created_at updated_at).freeze

    def jobs(scope = Job)
      @jobs ||= begin
        include_scopes = [:language, :company]
        include_scopes << user_include_scopes(:owner)

        prepare_records(scope.includes(*include_scopes))
      end
    end
  end
end
