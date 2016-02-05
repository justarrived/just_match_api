require 'rails_helper'

RSpec.describe UserLanguagePolicy do
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
    let(:language) { mock_model(Language, lang_code: 'en') }

    context '"self" user' do
      let(:context) { described_class::Context.new(user, nil) }
      let(:policy) { described_class.new(context, user_language) }
      let(:user_language) { mock_model(UserLanguage, user: user, language: language) }

      it 'allows access' do
        expect(policy.create?).to eq(true)
      end

      it 'allows access' do
        expect(policy.destroy?).to eq(true)
      end
    end

    context 'admin user' do
      let(:context) { described_class::Context.new(admin_user, nil) }
      let(:policy) { described_class.new(context, user_language) }
      let(:user_language) { mock_model(UserLanguage, user: user, language: language) }

      it 'allows access' do
        expect(policy.create?).to eq(true)
      end

      it 'allows access' do
        expect(policy.destroy?).to eq(true)
      end
    end

    context '*not* "self" user' do
      let(:context) { described_class::Context.new(user, nil) }
      let(:policy) { described_class.new(context, user_language) }
      let(:user_language) do
        mock_model(UserLanguage, user: other_user, language: language)
      end

      it 'denies access' do
        expect(policy.create?).to eq(false)
      end

      it 'allows access' do
        expect(policy.destroy?).to eq(false)
      end
    end
  end
end
