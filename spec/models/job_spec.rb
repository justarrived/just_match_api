require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'class queries' do
    describe '#matches_user'
  end

  describe '#send_performed_accept_notice?' do
    it 'returns true if notice should be sent' do
      job = described_class.new
      job.performed_accept = true
      expected = job.send_performed_accept_notice?
      expect(expected).to eq(true)
    end

    it 'returns false if notice should be sent' do
      job = described_class.new
      job.performed_accept = false
      expected = job.send_performed_accept_notice?
      expect(expected).to eq(false)
    end
  end

  describe '#accepted_applicant' do
    it 'returns nil if no accepted applicant' do
      job = described_class.new
      expect(job.accepted_applicant).to eq(nil)
    end

    it 'returns accepted user if no job user' do
      applicant = FactoryGirl.create(:user)
      owner = FactoryGirl.create(:user)
      job = FactoryGirl.create(:job, owner: owner)

      job.create_applicant!(applicant)
      job.accept_applicant!(applicant)

      expect(job.accepted_applicant).to eq(applicant)
    end
  end
end
