require 'rails_helper'

RSpec.describe JobSkillPolicy do
  let(:admin) { FactoryGirl.build(:admin_user) }
  let(:user) { FactoryGirl.build(:user) }
  let(:owner) { FactoryGirl.build(:user) }
  let(:skill) { FactoryGirl.build(:skill) }
  let(:job) { mock_model(Job, owner: owner) }
  let(:policy) { described_class.new(context, nil) }

  permissions :index?, :show? do
    let(:context) { described_class::Context.new(nil, nil) }

    it 'allows access for everyone' do
      expect(policy.index?).to eq(true)
    end

    it 'allows access for everyone' do
      expect(policy.show?).to eq(true)
    end
  end

  permissions :create?, :destroy? do
    context 'admin' do
      let(:context) { described_class::Context.new(admin, nil) }

      it 'allows access' do
        expect(policy.create?).to eq(true)
      end

      it 'allows access' do
        expect(policy.destroy?).to eq(true)
      end
    end

    context 'job owner' do
      let(:context) { described_class::Context.new(owner, job) }

      it 'allows access' do
        expect(policy.create?).to eq(true)
      end

      it 'allows access' do
        expect(policy.destroy?).to eq(true)
      end
    end

    context 'user' do
      let(:context) { described_class::Context.new(user, job) }

      it 'denies access' do
        expect(policy.create?).to eq(false)
      end

      it 'denies access' do
        expect(policy.destroy?).to eq(false)
      end
    end
  end
end
