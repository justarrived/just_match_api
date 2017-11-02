# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendLatestJobDigestService do
  describe '::call' do
    it 'sends emails for each matching job' do
      occ = FactoryBot.create(:occupation)
      occ1 = FactoryBot.create(:occupation)
      occ2 = FactoryBot.create(:occupation)
      occ3 = FactoryBot.create(:occupation)

      FactoryBot.create(:job, publish_at: 46.hours.ago)
      FactoryBot.create(
        :job,
        publish_at: 23.hours.ago,
        job_occupations: [JobOccupation.new(importance: :bonus, occupation: occ)]
      )
      FactoryBot.create(
        :job,
        publish_at: 1.hour.ago,
        job_occupations: [JobOccupation.new(importance: :bonus, occupation: occ2)]
      )
      FactoryBot.create(
        :job,
        publish_at: 1.hour.ago,
        job_occupations: [
          JobOccupation.new(importance: :bonus, occupation: occ),
          JobOccupation.new(importance: :bonus, occupation: occ1)
        ]
      )

      # Should match
      FactoryBot.create(:job_digest, occupations: [occ])
      FactoryBot.create(:job_digest, occupations: [occ, occ1])
      FactoryBot.create(:job_digest, occupations: [occ, occ2, occ3])
      # Should *not* match
      FactoryBot.create(:job_digest, occupations: [occ3])
      FactoryBot.create(:job_digest, occupations: [occ], deleted_at: 1.day.ago)

      total_sent = described_class.call(jobs_published_within_hours: 24)
      expect(total_sent).to eq(3)
    end
  end
end
