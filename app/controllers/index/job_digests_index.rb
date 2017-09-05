# frozen_string_literal: true

module Index
  class JobDigestsIndex < BaseIndex
    def job_digests(scope = JobDigest)
      @job_digests ||= prepare_records(scope)
    end
  end
end
