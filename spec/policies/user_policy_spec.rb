# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserPolicy do
  before(:each) do
    allow_any_instance_of(User).to receive(:persisted?).and_return(true)
  end

  context 'a user' do
    subject { UserPolicy.new(nil, user) }

    let(:user) { FactoryGirl.build(:user) }

    it 'returns false for index' do
      expect(subject.index?).to eq(false)
    end

    it 'returns false for show' do
      expect(subject.show?).to eq(false)
    end

    it 'returns true for create' do
      expect(subject.create?).to eq(true)
    end

    it 'returns false for update' do
      expect(subject.update?).to eq(false)
    end

    it 'returns false for destroy' do
      expect(subject.destroy?).to eq(false)
    end

    it 'returns false for matching_jobs' do
      expect(subject.matching_jobs?).to eq(false)
    end

    it 'returns false for jobs' do
      expect(subject.jobs?).to eq(false)
    end
  end

  context 'company user' do
    subject { UserPolicy.new(company_user, user) }

    let(:company_user) { FactoryGirl.build(:company_user) }
    let(:user) { FactoryGirl.build(:user) }

    it 'returns true for jobs' do
      expect(subject.jobs?).to eq(true)
    end
  end

  describe '#present_attributes' do
    subject { UserPolicy.new(user, owner) }

    let(:owner) { FactoryGirl.build(:user) }
    let(:user) { FactoryGirl.build(:user) }
    let(:admin) { FactoryGirl.build(:admin_user) }

    let(:job) { FactoryGirl.create(:job, owner: owner) }

    context 'accepted applicant for owner' do
      let!(:job_user) do
        FactoryGirl.create(:job_user, job: job, user: user, accepted: true)
      end

      it 'returns correct attributes' do
        expected = described_class::ACCEPTED_APPLICANT_ATTRIBUTES
        expect(subject.present_attributes).to eq(expected)
      end
    end

    context 'user' do
      it 'returns correct attributes' do
        expected = described_class::ATTRIBUTES
        expect(subject.present_attributes).to eq(expected)
      end
    end

    context 'admin' do
      subject { UserPolicy.new(admin, owner) }

      it 'returns correct attributes' do
        expected = described_class::SELF_ATTRIBUTES
        expect(subject.present_attributes).to eq(expected)
      end
    end

    context 'self user' do
      subject { UserPolicy.new(owner, owner) }

      it 'returns correct attributes' do
        expected = described_class::SELF_ATTRIBUTES
        expect(subject.present_attributes).to eq(expected)
      end
    end
  end

  context 'logged in user is user' do
    subject { UserPolicy.new(user, user) }

    let(:user) { FactoryGirl.build(:user) }

    it 'returns false for index' do
      expect(subject.index?).to eq(false)
    end

    it 'returns false for create' do
      expect(subject.create?).to eq(true)
    end

    it 'returns true for show' do
      expect(subject.show?).to eq(true)
    end

    it 'returns true for update' do
      expect(subject.update?).to eq(true)
    end

    it 'returns true for destroy' do
      expect(subject.destroy?).to eq(true)
    end

    it 'returns true for matching_jobs' do
      expect(subject.matching_jobs?).to eq(true)
    end

    it 'returns true for jobs' do
      expect(subject.jobs?).to eq(true)
    end
  end

  context 'admin user' do
    subject { UserPolicy.new(admin, user) }

    let(:admin) { FactoryGirl.build(:admin_user) }
    let(:user) { FactoryGirl.build(:user) }

    it 'returns true for index' do
      expect(subject.index?).to eq(true)
    end

    it 'returns true for create' do
      expect(subject.create?).to eq(true)
    end

    it 'returns true for show' do
      expect(subject.show?).to eq(true)
    end

    it 'returns update for update' do
      expect(subject.update?).to eq(true)
    end

    it 'returns true for destroy' do
      expect(subject.destroy?).to eq(true)
    end

    it 'returns true for matching_jobs' do
      expect(subject.matching_jobs?).to eq(true)
    end

    it 'returns true for jobs' do
      expect(subject.jobs?).to eq(true)
    end
  end
end
