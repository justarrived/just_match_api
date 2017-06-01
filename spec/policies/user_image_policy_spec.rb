# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserImagePolicy do
  before(:each) do
    allow_any_instance_of(User).to receive(:persisted?).and_return(true)
  end

  let(:user) { FactoryGirl.build(:user) }
  let(:user_image) { FactoryGirl.build(:user_image, user: user) }
  let(:a_user) { FactoryGirl.build(:user) }
  let(:admin_user) { FactoryGirl.build(:admin_user) }
  let(:policy) { described_class.new(policy_context, user_image) }

  permissions :show? do
    context 'admin' do
      let(:policy_context) { admin_user }

      it 'allows access' do
        expect(policy.show?).to eq(true)
      end
    end

    context 'a user' do
      let(:policy_context) { a_user }

      it 'denies access' do
        expect(policy.show?).to eq(false)
      end
    end

    context 'current user' do
      let(:policy_context) { user }

      it 'denies access' do
        expect(policy.show?).to eq(true)
      end
    end
  end

  permissions :images? do
    context 'admin' do
      let(:policy_context) { admin_user }

      it 'allows access' do
        expect(policy.images?).to eq(true)
      end
    end

    context 'a user' do
      let(:policy_context) { a_user }

      it 'allows access' do
        expect(policy.images?).to eq(true)
      end
    end

    context 'current user' do
      let(:policy_context) { user }

      it 'denies access' do
        expect(policy.images?).to eq(true)
      end
    end

    context 'no user' do
      let(:policy_context) { nil }

      it 'denies access' do
        expect(policy.images?).to eq(true)
      end
    end
  end

  permissions :create? do
    context 'admin' do
      let(:policy_context) { admin_user }

      it 'allows access' do
        expect(policy.create?).to eq(true)
      end
    end

    context 'a user' do
      let(:policy_context) { a_user }

      it 'allows access' do
        expect(policy.create?).to eq(true)
      end
    end

    context 'current user' do
      let(:policy_context) { user }

      it 'denies access' do
        expect(policy.create?).to eq(true)
      end
    end

    context 'no user' do
      let(:policy_context) { nil }

      it 'denies access' do
        expect(policy.create?).to eq(true)
      end
    end
  end
end
