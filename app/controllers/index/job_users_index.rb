# frozen_string_literal: true
module Index
  class JobUsersIndex < BaseIndex
    SORTABLE_FIELDS = %i(created_at).freeze

    def job_users
      @job_users ||= prepare_records(JobUser)
    end
  end
end
