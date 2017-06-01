# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InterestPolicy do
  before(:each) do
    allow_any_instance_of(User).to receive(:persisted?).and_return(true)
  end

  context 'anyone' do
    subject { InterestPolicy.new(nil, interest) }

    let(:interest) { FactoryGirl.build(:interest) }

    it 'returns true for index' do
      expect(subject.index?).to eq(true)
    end

    it 'returns true for show' do
      expect(subject.show?).to eq(true)
    end
  end
end
