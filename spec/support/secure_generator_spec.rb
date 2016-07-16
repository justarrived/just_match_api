# frozen_string_literal: true
require 'spec_helper'

RSpec.describe SecureGenerator do
  describe '#generate' do
    subject { described_class.token }

    it 'generates token' do
      expect(subject.length).to eq(96)
    end

    context 'length option' do
      let(:length) { 48 }
      subject { described_class.token(length: length) }

      it 'generates token with given length' do
        expect(subject.length).to eq(length)
      end
    end
  end
end
