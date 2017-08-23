# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendLatestJobDigestService do
  describe '::call' do
    it 'sends emails for each matching job' do
      occ = FactoryGirl.create(:occupation)
      occ1 = FactoryGirl.create(:occupation)
      occ2 = FactoryGirl.create(:occupation)
      occ3 = FactoryGirl.create(:occupation)

      FactoryGirl.create(:job, publish_at: 46.hours.ago)
      FactoryGirl.create(
        :job,
        publish_at: 23.hours.ago,
        job_occupations: [JobOccupation.new(importance: :bonus, occupation: occ)]
      )
      FactoryGirl.create(
        :job,
        publish_at: 1.hour.ago,
        job_occupations: [JobOccupation.new(importance: :bonus, occupation: occ2)]
      )
      FactoryGirl.create(
        :job,
        publish_at: 1.hour.ago,
        job_occupations: [
          JobOccupation.new(importance: :bonus, occupation: occ),
          JobOccupation.new(importance: :bonus, occupation: occ1)
        ]
      )

      FactoryGirl.create(:job_digest, occupations: [occ])
      FactoryGirl.create(:job_digest, occupations: [occ, occ1])
      FactoryGirl.create(:job_digest, occupations: [occ, occ2, occ3])
      FactoryGirl.create(:job_digest, occupations: [occ3])

      allow(SendJobDigestNotificationsService).to receive(:call).and_return(nil)
      described_class.call(jobs_published_within_hours: 24)
      expect(SendJobDigestNotificationsService).to receive(:call).once
    end
  end
end
