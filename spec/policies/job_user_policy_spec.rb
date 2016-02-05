require 'rails_helper'

RSpec.describe JobUserPolicy do
  let(:owner) { FactoryGirl.build(:user) }
  let(:user) { FactoryGirl.build(:user) }
  let(:a_job_user) { FactoryGirl.build(:user) }
  let(:admin_user) { FactoryGirl.build(:admin_user) }
  let(:job) { mock_model(Job, owner: owner, users: [a_job_user]) }
  let(:policy) { described_class.new(context, nil) }

  permissions :index? do
    context 'job owner' do
      let(:context) { described_class::Context.new(owner, job, a_job_user) }

      it 'allows access' do
        expect(policy.index?).to eq(true)
      end
    end

    context 'admin' do
      let(:context) { described_class::Context.new(admin_user, job, a_job_user) }

      it 'allows access' do
        expect(policy.index?).to eq(true)
      end
    end

    context 'job user' do
      let(:context) { described_class::Context.new(a_job_user, job, a_job_user) }

      it 'denies access' do
        expect(policy.index?).to eq(false)
      end
    end

    context 'a user' do
      let(:context) { described_class::Context.new(user, job, a_job_user) }

      it 'denies access' do
        expect(policy.index?).to eq(false)
      end
    end
  end

  permissions :show? do
    context 'job owner' do
      let(:context) { described_class::Context.new(owner, job, a_job_user) }

      it 'allows access' do
        expect(policy.show?).to eq(true)
      end
    end

    context 'admin' do
      let(:context) { described_class::Context.new(admin_user, job, a_job_user) }

      it 'allows access' do
        expect(policy.show?).to eq(true)
      end
    end

    context 'job user' do
      let(:context) { described_class::Context.new(a_job_user, job, a_job_user) }

      it 'allows access' do
        expect(policy.show?).to eq(true)
      end
    end

    context 'a user' do
      let(:context) { described_class::Context.new(user, job, a_job_user) }

      it 'denies access' do
        expect(policy.show?).to eq(false)
      end
    end
  end

  permissions :create? do
    context 'a user' do
      let(:context) { described_class::Context.new(user, job, a_job_user) }

      it 'allows access' do
        expect(policy.create?).to eq(true)
      end
    end

    context 'no user' do
      let(:context) { described_class::Context.new(nil, job, a_job_user) }

      it 'denies access' do
        expect(policy.create?).to eq(false)
      end
    end
  end

  permissions :update? do
    context 'job owner' do
      let(:context) { described_class::Context.new(owner, job, a_job_user) }

      it 'allows access' do
        expect(policy.update?).to eq(true)
      end
    end

    context 'admin' do
      let(:context) { described_class::Context.new(admin_user, job, a_job_user) }

      it 'allows access' do
        expect(policy.update?).to eq(true)
      end
    end

    context 'job user' do
      let(:context) { described_class::Context.new(a_job_user, job, a_job_user) }

      it 'denies access' do
        expect(policy.update?).to eq(false)
      end
    end

    context 'a user' do
      let(:context) { described_class::Context.new(user, job, a_job_user) }

      it 'denies access' do
        expect(policy.update?).to eq(false)
      end
    end
  end

  permissions :destroy? do
    context 'job owner' do
      let(:context) { described_class::Context.new(owner, job, a_job_user) }

      it 'denies access' do
        expect(policy.destroy?).to eq(false)
      end
    end

    context 'admin' do
      let(:context) { described_class::Context.new(admin_user, job, a_job_user) }

      it 'allows access' do
        expect(policy.destroy?).to eq(true)
      end
    end

    context 'job user' do
      let(:context) { described_class::Context.new(a_job_user, job, a_job_user) }

      it 'allows access' do
        expect(policy.destroy?).to eq(true)
      end
    end

    context 'a user' do
      let(:context) { described_class::Context.new(user, job, a_job_user) }

      it 'denies access' do
        expect(policy.destroy?).to eq(false)
      end
    end
  end
end
