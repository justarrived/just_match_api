# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserPolicy do
  context 'a user' do
    subject { UserPolicy.new(nil, user) }

    let(:user) { FactoryGirl.create(:user) }

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
