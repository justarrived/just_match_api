# frozen_string_literal: true
module Index
  class JobsIndex < BaseIndex
    SORTABLE_FIELDS = %i(created_at hours job_date)

    def jobs
      @jobs ||= policy_scope(Job).
                  includes(:owner, :comments, :language, :company).
                  order(sort_params).
                  page(current_page).per(current_size)
    end
  end
end
