# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Queries::SkillMatcher do
  describe '#perform' do
    describe 'no match' do
      it 'returns empty ActiveRecord relation' do
        job = FactoryGirl.create(:job)
        result = described_class.new(User, job).perform
        expect(result.length).to be_zero
      end

      it 'returns empty ActiveRecord relation' do
        job = FactoryGirl.create(:job)
        result = described_class.new(User, job).perform(strict_match: true)
        expect(result.length).to be_zero
      end
    end

    describe 'matching' do
      let(:job) { FactoryGirl.create(:job_with_skills, skills_count: 2) }
      let(:first_user) { FactoryGirl.create(:user) }
      let(:other_user) { FactoryGirl.create(:user) }

      describe 'single' do
        it 'returns matching record' do
          first_user.skills = job.skills
          result = described_class.new(User, job).perform
          expect(result).to eq([first_user])
        end

        it 'returns strict matching record' do
          first_user.skills = job.skills
          result = described_class.new(User, job).perform(strict_match: true)
          expect(result).to eq([first_user])
        end
      end

      describe 'multiple matches' do
        it 'returns matching records' do
          first_user.skills = job.skills
          other_user.skills = job.skills
          result = described_class.new(User, job).perform
          expect(result).to match_array([first_user, other_user])
        end

        it 'returns strict matching records' do
          first_user.skills = job.skills
          other_user.skills = [job.skills.first]
          result = described_class.new(User, job).perform(strict_match: true)
          expect(result).to match_array([first_user])
        end
      end
    end
  end
end
