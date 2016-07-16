# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JobUserPolicy do
  before(:each) do
    allow_any_instance_of(User).to receive(:persisted?).and_return(true)
  end

  let(:owner) { FactoryGirl.build(:user) }
  let(:user) { FactoryGirl.build(:user) }
  let(:a_job_user) { FactoryGirl.build(:user) }
  let(:admin_user) { FactoryGirl.build(:admin_user) }
  let(:job) { mock_model(Job, owner: owner, users: [a_job_user]) }
  let(:policy) { described_class.new(policy_context, nil) }

  permissions :index? do
    context 'job owner' do
      let(:policy_context) { described_class::Context.new(owner, job, a_job_user) }

      it 'allows access' do
        expect(policy.index?).to eq(true)
      end
    end

    context 'admin' do
      let(:policy_context) { described_class::Context.new(admin_user, job, a_job_user) }

      it 'allows access' do
        expect(policy.index?).to eq(true)
      end
    end

    context 'job user' do
      let(:policy_context) { described_class::Context.new(a_job_user, job, a_job_user) }

      it 'denies access' do
        expect(policy.index?).to eq(false)
      end
    end

    context 'a user' do
      let(:policy_context) { described_class::Context.new(user, job, a_job_user) }

      it 'denies access' do
        expect(policy.index?).to eq(false)
      end
    end
  end

  permissions :show? do
    context 'job owner' do
      let(:policy_context) { described_class::Context.new(owner, job, a_job_user) }

      it 'allows access' do
        expect(policy.show?).to eq(true)
      end
    end

    context 'admin' do
      let(:policy_context) { described_class::Context.new(admin_user, job, a_job_user) }

      it 'allows access' do
        expect(policy.show?).to eq(true)
      end
    end

    context 'job user' do
      let(:policy_context) { described_class::Context.new(a_job_user, job, a_job_user) }

      it 'allows access' do
        expect(policy.show?).to eq(true)
      end
    end

    context 'a user' do
      let(:policy_context) { described_class::Context.new(user, job, a_job_user) }

      it 'denies access' do
        expect(policy.show?).to eq(false)
      end
    end
  end

  permissions :create? do
    context 'a user' do
      let(:policy_context) { described_class::Context.new(user, job, a_job_user) }

      it 'allows access' do
        expect(policy.create?).to eq(true)
      end
    end

    context 'no user' do
      let(:policy_context) { described_class::Context.new(nil, job, a_job_user) }

      it 'denies access' do
        expect(policy.create?).to eq(false)
      end
    end
  end

  permissions :update? do
    context 'job owner' do
      let(:policy_context) { described_class::Context.new(owner, job, a_job_user) }

      it 'allows access' do
        expect(policy.update?).to eq(true)
      end
    end

    context 'admin' do
      let(:policy_context) { described_class::Context.new(admin_user, job, a_job_user) }

      it 'allows access' do
        expect(policy.update?).to eq(true)
      end
    end

    context 'job user' do
      let(:policy_context) { described_class::Context.new(a_job_user, job, a_job_user) }

      it 'denies access' do
        expect(policy.update?).to eq(true)
      end
    end

    context 'a user' do
      let(:policy_context) { described_class::Context.new(user, job, a_job_user) }

      it 'denies access' do
        expect(policy.update?).to eq(false)
      end
    end
  end

  permissions :destroy? do
    context 'job owner' do
      let(:policy_context) { described_class::Context.new(owner, job, a_job_user) }

      it 'denies access' do
        expect(policy.destroy?).to eq(false)
      end
    end

    context 'admin' do
      let(:policy_context) { described_class::Context.new(admin_user, job, a_job_user) }

      it 'allows access' do
        expect(policy.destroy?).to eq(true)
      end
    end

    context 'job user' do
      let(:policy_context) { described_class::Context.new(a_job_user, job, a_job_user) }

      it 'allows access' do
        expect(policy.destroy?).to eq(true)
      end
    end

    context 'a user' do
      let(:policy_context) { described_class::Context.new(user, job, a_job_user) }

      it 'denies access' do
        expect(policy.destroy?).to eq(false)
      end
    end
  end

  describe '#permitted_attributes' do
    context 'job owner' do
      let(:policy_context) { described_class::Context.new(owner, job, a_job_user) }

      it 'returns correct attributes' do
        expect(policy.permitted_attributes).to eq([:accepted])
      end
    end

    context 'admin' do
      let(:policy_context) { described_class::Context.new(admin_user, job, a_job_user) }

      it 'returns correct attributes' do
        expected = %i(accepted will_perform performed apply_message)
        expect(policy.permitted_attributes).to eq(expected)
      end
    end

    context 'job user' do
      let(:policy_context) { described_class::Context.new(a_job_user, job, a_job_user) }

      it 'returns correct attributes' do
        expected = [:will_perform, :performed, :apply_message]
        expect(policy.permitted_attributes).to eq(expected)
      end
    end

    context 'a user' do
      let(:policy_context) { described_class::Context.new(user, job, a_job_user) }

      it 'returns correct attributes' do
        expect(policy.permitted_attributes).to eq([])
      end
    end
  end
end
