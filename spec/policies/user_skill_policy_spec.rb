require 'rails_helper'

RSpec.describe UserSkillPolicy do
  let(:user) { FactoryGirl.build(:user) }
  let(:other_user) { FactoryGirl.build(:user) }
  let(:admin_user) { FactoryGirl.build(:admin_user) }

  permissions :index?, :show? do
    context '"self" user' do
      let(:context) { described_class::Context.new(user, user) }
      let(:policy) { described_class.new(context, nil) }

      it 'allows access' do
        expect(policy.index?).to eq(true)
      end

      it 'allows access' do
        expect(policy.show?).to eq(true)
      end
    end

    context 'admin user' do
      let(:context) { described_class::Context.new(admin_user, user) }
      let(:policy) { described_class.new(context, nil) }

      it 'allows access' do
        expect(policy.index?).to eq(true)
      end

      it 'allows access' do
        expect(policy.show?).to eq(true)
      end
    end

    context '*not* "self" user' do
      let(:context) { described_class::Context.new(user, other_user) }
      let(:policy) { described_class.new(context, nil) }

      it 'denies access' do
        expect(policy.index?).to eq(false)
      end

      it 'allows access' do
        expect(policy.show?).to eq(false)
      end
    end
  end

  permissions :create?, :destroy? do
    let(:skill) { mock_model(Skill, name: 'Skill') }

    context '"self" user' do
      let(:context) { described_class::Context.new(user, nil) }
      let(:policy) { described_class.new(context, user_skill) }
      let(:user_skill) { mock_model(UserSkill, user: user, skill: skill) }

      it 'allows access' do
        expect(policy.create?).to eq(true)
      end

      it 'allows access' do
        expect(policy.destroy?).to eq(true)
      end
    end

    context 'admin user' do
      let(:context) { described_class::Context.new(admin_user, nil) }
      let(:policy) { described_class.new(context, user_skill) }
      let(:user_skill) { mock_model(UserSkill, user: user, skill: skill) }

      it 'allows access' do
        expect(policy.create?).to eq(true)
      end

      it 'allows access' do
        expect(policy.destroy?).to eq(true)
      end
    end

    context '*not* "self" user' do
      let(:context) { described_class::Context.new(user, nil) }
      let(:policy) { described_class.new(context, user_skill) }
      let(:user_skill) { mock_model(UserSkill, user: other_user, skill: skill) }

      it 'denies access' do
        expect(policy.create?).to eq(false)
      end

      it 'allows access' do
        expect(policy.destroy?).to eq(false)
      end
    end
  end
end
