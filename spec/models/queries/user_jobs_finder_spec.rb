require 'rails_helper'

RSpec.describe Queries::UserJobsFinder do
  let(:user) { FactoryGirl.create(:user) }

  describe '#perform' do
    it 'returns empty job scope if no related jobs are found for user' do
      expect(described_class.new(user).perform).to eq(Job.none)
    end

    it 'returns empty list if user is nil' do
      expect(described_class.new(nil).perform).to eq([])
    end

    it 'returns onwed jobs' do
      job = FactoryGirl.create(:job, owner: user)
      expect(described_class.new(user).perform).to eq([job])
    end

    it 'returns applicant jobs' do
      job = FactoryGirl.create(:job, users: [user])
      expect(described_class.new(user).perform).to eq([job])
    end

    it 'returns both owned jobs and applicant jobs' do
      owned_job = FactoryGirl.create(:job, owner: user)
      applicant_job = FactoryGirl.create(:job, users: [user])
      result = described_class.new(user).perform
      expect(result).to include(owned_job)
      expect(result).to include(applicant_job)
    end
  end
end
