# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmploymentPeriod, type: :model do
  describe '#ongoing?' do
    it 'returns true if the job is ongoing' do
      job = FactoryBot.build_stubbed(
        :employment_period,
        started_at: 1.day.ago,
        ended_at: 1.day.from_now
      )
      expect(job.ongoing?).to eq(true)
    end

    it 'returns false if the job is in the future' do
      job = FactoryBot.build_stubbed(
        :employment_period,
        started_at: 1.day.from_now,
        ended_at: 5.days.from_now
      )
      expect(job.ongoing?).to eq(false)
    end

    it 'returns false if the job is in the passed' do
      job = FactoryBot.build_stubbed(
        :employment_period,
        started_at: 2.days.ago,
        ended_at: 1.day.ago
      )
      expect(job.ongoing?).to eq(false)
    end

    it 'returns true if started_at is in the past and ended_at is not set' do
      job = FactoryBot.build_stubbed(
        :employment_period,
        started_at: 2.days.ago,
        ended_at: nil
      )
      expect(job.ongoing?).to eq(true)
    end
  end
end

# == Schema Information
#
# Table name: employment_periods
#
#  id                 :bigint(8)        not null, primary key
#  job_id             :bigint(8)
#  user_id            :bigint(8)
#  employer_signed_at :datetime
#  employee_signed_at :datetime
#  started_at         :datetime
#  ended_at           :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  percentage         :decimal(, )
#
# Indexes
#
#  index_employment_periods_on_job_id   (job_id)
#  index_employment_periods_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (user_id => users.id)
#
