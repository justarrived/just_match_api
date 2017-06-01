# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserInterestPolicy do
  before(:each) do
    allow_any_instance_of(User).to receive(:persisted?).and_return(true)
  end

  let(:user) { FactoryGirl.build(:user) }
  let(:other_user) { FactoryGirl.build(:user) }
  let(:admin_user) { FactoryGirl.build(:admin_user) }

  permissions :index?, :show? do
    context '"self" user' do
      let(:policy_context) { described_class::Context.new(user, user) }
      let(:policy) { described_class.new(policy_context, nil) }

      it 'allows access' do
        expect(policy.index?).to eq(true)
      end

      it 'allows access' do
        expect(policy.show?).to eq(true)
      end
    end

    context 'admin user' do
      let(:policy_context) { described_class::Context.new(admin_user, user) }
      let(:policy) { described_class.new(policy_context, nil) }

      it 'allows access' do
        expect(policy.index?).to eq(true)
      end

      it 'allows access' do
        expect(policy.show?).to eq(true)
      end
    end

    context '*not* "self" user' do
      let(:policy_context) { described_class::Context.new(user, other_user) }
      let(:policy) { described_class.new(policy_context, nil) }

      it 'denies access' do
        expect(policy.index?).to eq(false)
      end

      it 'allows access' do
        expect(policy.show?).to eq(false)
      end
    end
  end

  permissions :create?, :destroy? do
    let(:interest) { mock_model(Skill, name: 'Skill') }

    context '"self" user' do
      let(:policy_context) { described_class::Context.new(user, nil) }
      let(:policy) { described_class.new(policy_context, user_interest) }
      let(:user_interest) { mock_model(UserInterest, user: user, interest: interest) }

      it 'allows access' do
        expect(policy.create?).to eq(true)
      end

      it 'allows access' do
        expect(policy.destroy?).to eq(true)
      end
    end

    context 'admin user' do
      let(:policy_context) { described_class::Context.new(admin_user, nil) }
      let(:policy) { described_class.new(policy_context, user_interest) }
      let(:user_interest) { mock_model(UserInterest, user: user, interest: interest) }

      it 'allows access' do
        expect(policy.create?).to eq(true)
      end

      it 'allows access' do
        expect(policy.destroy?).to eq(true)
      end
    end

    context '*not* "self" user' do
      let(:policy_context) { described_class::Context.new(user, nil) }
      let(:policy) { described_class.new(policy_context, user_interest) }
      let(:user_interest) { mock_model(UserInterest, user: other_user, interest: interest) } # rubocop:disable Metrics/LineLength

      it 'denies access' do
        expect(policy.create?).to eq(false)
      end

      it 'allows access' do
        expect(policy.destroy?).to eq(false)
      end
    end
  end
end
