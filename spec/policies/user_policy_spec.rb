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

    it 'returns false for create_document' do
      expect(subject.create_document?).to eq(false)
    end

    it 'returns false for index_document' do
      expect(subject.index_document?).to eq(false)
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

    it 'returns false for ratings' do
      expect(subject.ratings?).to eq(false)
    end

    it 'returns false for owned jobs' do
      expect(subject.owned_jobs?).to eq(false)
    end
  end

  context 'company user' do
    subject { UserPolicy.new(company_user, user) }

    let(:company_user) { FactoryGirl.build(:company_user) }
    let(:user) { FactoryGirl.build(:user) }

    it 'returns true for jobs' do
      expect(subject.jobs?).to eq(true)
    end

    it 'returns true for ratings' do
      expect(subject.ratings?).to eq(true)
    end

    it 'returns false for owned jobs' do
      expect(subject.owned_jobs?).to eq(false)
    end
  end

  describe '#present_attributes' do
    subject { UserPolicy.new(user, owner) }

    let(:language) { Language.find_or_create_by!(lang_code: 'en') }

    let(:owner) { FactoryGirl.build(:company_user, language: language) }
    let(:user) { FactoryGirl.build(:user, language: language) }
    let(:admin) { FactoryGirl.build(:admin_user) }

    let(:job) { FactoryGirl.create(:job, owner: owner) }

    context 'accepted applicant for owner' do
      it 'returns correct attributes' do
        FactoryGirl.create(:job_user, job: job, user: user, accepted: true)
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

    it 'returns true for create_document' do
      expect(subject.create_document?).to eq(true)
    end

    it 'returns true for index_document' do
      expect(subject.index_document?).to eq(true)
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

    it 'returns true for ratings' do
      expect(subject.ratings?).to eq(true)
    end

    it 'returns true for owned jobs' do
      expect(subject.owned_jobs?).to eq(true)
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

    it 'returns true for create_document' do
      expect(subject.create_document?).to eq(true)
    end

    it 'returns true for index_document' do
      expect(subject.index_document?).to eq(true)
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

    it 'returns true for ratings' do
      expect(subject.ratings?).to eq(true)
    end

    it 'returns true for owned jobs' do
      expect(subject.owned_jobs?).to eq(true)
    end
  end

  permissions :notifications? do
    subject { UserPolicy.new(nil, nil) }

    it 'allows access for everyone' do
      expect(subject.notifications?).to eq(true)
    end
  end

  permissions :statuses? do
    subject { UserPolicy.new(nil, nil) }

    it 'allows access for everyone' do
      expect(subject.statuses?).to eq(true)
    end
  end

  permissions :genders? do
    subject { UserPolicy.new(nil, nil) }

    it 'allows access for everyone' do
      expect(subject.genders?).to eq(true)
    end
  end
end
