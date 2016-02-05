require 'rails_helper'

RSpec.describe JobPolicy do
  context 'anyone' do
    subject { JobPolicy.new(nil, job) }

    let(:job) { FactoryGirl.build(:job) }

    it 'returns true for index' do
      expect(subject.index?).to eq(true)
    end

    it 'returns true for show' do
      expect(subject.show?).to eq(true)
    end

    it 'returns false for create' do
      expect(subject.create?).to eq(false)
    end

    it 'returns false for update' do
      expect(subject.update?).to eq(false)
    end

    it 'returns false for matching_users' do
      expect(subject.matching_users?).to eq(false)
    end
  end

  context 'user' do
    subject { JobPolicy.new(user, job) }

    let(:user) { FactoryGirl.build(:user) }
    let(:job) { FactoryGirl.build(:job) }

    it 'returns true for create' do
      expect(subject.create?).to eq(true)
    end

    it 'returns update for update' do
      expect(subject.update?).to eq(true)
    end

    it 'returns false for matching_users' do
      expect(subject.matching_users?).to eq(false)
    end
  end

  context 'owner user' do
    subject { JobPolicy.new(user, job) }

    let(:user) { FactoryGirl.build(:user) }
    let(:job) { FactoryGirl.build(:job, owner: user) }

    it 'returns true for matching_users' do
      expect(subject.matching_users?).to eq(true)
    end
  end

  context 'admin user' do
    subject { JobPolicy.new(admin, job) }

    let(:admin) { FactoryGirl.build(:admin_user) }
    let(:job) { FactoryGirl.build(:job) }

    it 'returns true for matching_users' do
      expect(subject.matching_users?).to eq(true)
    end
  end
end
