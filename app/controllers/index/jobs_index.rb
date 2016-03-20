# frozen_string_literal: true
module Index
  class JobsIndex < BaseIndex
    SORTABLE_FIELDS = %i(created_at hours job_date name).freeze

    def jobs
      @jobs ||= begin
        records = Job.includes(:owner, :comments, :language, :company)
        prepare_records(records)
      end
    end
  end
end
