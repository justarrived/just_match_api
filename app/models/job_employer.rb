# frozen_string_literal: true

class JobEmployer
  attr_reader :job, :employer

  delegate_missing_to :@employer

  def initialize(job)
    @job = job
    @employer = calculate_employer(job)
  end

  def description
    employer.guaranteed_description
  end

  private

  def calculate_employer(job)
    return job.staffing_company if job.staffing_company

    job.company
  end
end
