# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ahoy::EventPolicy do
  permissions :create? do
    let(:policy) { described_class.new(nil, Ahoy::EventPolicy) }

    it 'allows access' do
      expect(policy.create?).to eq(true)
    end
  end
end
