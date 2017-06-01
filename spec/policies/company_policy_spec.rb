# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompanyPolicy do
  before(:each) do
    allow_any_instance_of(User).to receive(:persisted?).and_return(true)
  end

  let(:company) { FactoryGirl.build(:company) }
  let(:policy) { described_class.new(nil, company) }

  permissions :index? do
    context 'a user' do
      it 'allows access' do
        expect(policy.index?).to eq(true)
      end
    end
  end

  permissions :show? do
    context 'a user' do
      it 'allows access' do
        expect(policy.show?).to eq(true)
      end
    end
  end

  permissions :create? do
    context 'a user' do
      it 'allows access' do
        expect(policy.create?).to eq(true)
      end
    end
  end
end
