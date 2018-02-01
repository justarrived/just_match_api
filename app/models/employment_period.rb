# frozen_string_literal: true

class EmploymentPeriod < ApplicationRecord
  belongs_to :job_user, optional: true
  belongs_to :user, optional: true
end
