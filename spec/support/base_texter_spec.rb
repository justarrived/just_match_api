# frozen_string_literal: true
require 'spec_helper'

RSpec.describe BaseTexter do
  let(:from) { '+46735000000' }
  let(:to) { '+46735000000' }
  let(:body) { 'Watwoman' }
  subject { described_class.new(from: from, to: to, body: body) }

  describe '#deliver_now' do
    it 'sends text message' do
      subject.deliver_now
      last_message = FakeSMS.messages.last

      expect(last_message.to).to eq(to)
      expect(last_message.body).to eq(body)
    end
  end

  describe '#text' do
    it "returns an instance of #{described_class.name}" do
      expect(described_class.text(to: to, body: body)).to be_a(BaseTexter)
    end
  end
end
