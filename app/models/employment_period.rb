# frozen_string_literal: true

class EmploymentPeriod < ApplicationRecord
  belongs_to :job_user
  belongs_to :user
end
