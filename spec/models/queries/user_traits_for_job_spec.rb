# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::UserTraitsForJob do
  describe '#missing_user_attributes' do
    it 'with missing user attributes it returns a list of missing attribute names' do
      user = User.new
      expected = %w(ssn street zip city phone)
      expect(described_class.missing_user_attributes(user)).to include(*expected)
    end

    it 'with *no* missing user attributes it returns an empty list' do
      user = FactoryGirl.build(:user)
      expect(described_class.missing_user_attributes(user: user)).to be_empty
    end
  end

  describe '#missing_skills' do
    let(:job_with_skills) { FactoryGirl.create(:job_with_skills) }
    let(:job) { FactoryGirl.create(:job) }
    let(:user) { FactoryGirl.create(:user) }

    it 'with missing skills it returns a collection of those skills' do
      missing_skills = described_class.missing_skills(job: job_with_skills, user: user)
      expect(missing_skills).to eq(job_with_skills.skills)
    end

    it 'with *no* missing skills it returns an empty list' do
      missing_skills = described_class.missing_skills(job: job, user: user)
      expect(missing_skills).to eq([])
    end
  end

  describe '#missing_languages' do
    let(:job_with_languages) { FactoryGirl.create(:job_with_languages) }
    let(:job) { FactoryGirl.create(:job) }
    let(:user) { FactoryGirl.create(:user) }

    it 'with missing languages it returns a collection of those languages' do
      missing_languages = described_class.missing_languages(job: job_with_languages, user: user) # rubocop:disable Metrics/LineLength
      expect(missing_languages).to eq(job_with_languages.languages)
    end

    it 'with *no* missing languages it returns an empty list' do
      missing_languages = described_class.missing_languages(job: job, user: user)
      expect(missing_languages).to eq([])
    end
  end
end
