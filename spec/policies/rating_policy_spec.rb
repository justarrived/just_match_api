# frozen_string_literal: true
require 'rails_helper'

RSpec.describe RatingPolicy do
  before(:each) do
    allow_any_instance_of(User).to receive(:persisted?).and_return(true)
  end

  let(:admin) { FactoryGirl.build(:admin_user) }
  let(:user) { FactoryGirl.build(:user) }
  let(:job_owner) { FactoryGirl.build(:user) }
  let(:job) { FactoryGirl.build(:job, owner: job_owner) }
  let(:policy) { described_class.new(policy_context, nil) }

  permissions :create? do
    context 'admin' do
      let(:policy_context) { described_class::Context.new(admin, job) }

      it 'allows access' do
        expect(policy.create?).to eq(false)
      end

      it 'calls Rating#user_allowed_to_rate?' do
        expect(Rating).to receive(:user_allowed_to_rate?).with(job: job, user: admin)
        policy.create?
      end
    end

    context 'a user' do
      let(:policy_context) { described_class::Context.new(user, job) }

      it 'allows access' do
        expect(policy.create?).to eq(false)
      end

      it 'calls Rating#user_allowed_to_rate?' do
        expect(Rating).to receive(:user_allowed_to_rate?).with(job: job, user: user)
        policy.create?
      end
    end

    context 'job owner user' do
      let(:policy_context) { described_class::Context.new(job_owner, job) }

      it 'allows access' do
        expect(policy.create?).to eq(true)
      end

      it 'calls Rating#user_allowed_to_rate?' do
        expect(Rating).to receive(:user_allowed_to_rate?).with(job: job, user: job_owner)
        policy.create?
      end
    end

    context 'accepted applicant user' do
      let(:user) { FactoryGirl.create(:user) }
      let(:policy_context) { described_class::Context.new(user, job) }
      let(:policy) { described_class.new(policy_context, nil) }

      it 'allows access' do
        FactoryGirl.create(:job_user, job: job, user: user, accepted: true)

        expect(policy.create?).to eq(true)
      end

      it 'calls Rating#user_allowed_to_rate?' do
        expect(Rating).to receive(:user_allowed_to_rate?).with(job: job, user: user)
        policy.create?
      end
    end
  end
end
