# frozen_string_literal: true

class JobEmployer
  attr_reader :job, :employer

  delegate_missing_to :@employer

  def initialize(job)
    @job = job
    @employer = set_employer(job)
  end

  def description
    employer.guaranteed_description
  end

  private

  def set_employer(job)
    # TODO: just arrived bemmanning
    # WARNING: If we perform a SQL-query here, its going to cause a MAJOR N+1
    raise(NotImplementedError) if job.staffing_job

    @employer = job.company
  end
end
