# frozen_string_literal: true

FactoryBot.define do
  factory :employment_period do
    job_user nil
    user nil
    employer_signed_at '2018-02-01 20:58:53'
    employee_signed_at '2018-02-01 20:58:53'
    started_at '2018-02-01 20:58:53'
    ended_at '2018-02-01 20:58:53'
  end
end
