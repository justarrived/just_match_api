# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompanyImagePolicy do
  before(:each) do
    allow_any_instance_of(User).to receive(:persisted?).and_return(true)
  end

  let(:company_image) { FactoryGirl.build(:company_image) }
  let(:policy) { described_class.new(policy_context, company_image) }

  permissions :show? do
    context 'no user' do
      let(:policy_context) { nil }

      it 'denies access' do
        expect(policy.show?).to eq(true)
      end
    end
  end

  permissions :create? do
    context 'no user' do
      let(:policy_context) { nil }

      it 'denies access' do
        expect(policy.create?).to eq(true)
      end
    end
  end
end
