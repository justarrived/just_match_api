# frozen_string_literal: true
require 'spec_helper'

RSpec.describe SMSClient do
  describe '#send_message' do
    let(:from) { '+46735000000' }
    let(:to) { '+46735000000' }
    let(:body) { 'Watman!' }
    subject { described_class.new }

    it 'sends text message' do
      subject.send_message(from: from, to: to, body: body)
      last_message = FakeSMS.messages.last

      expect(last_message.from).to eq(from)
      expect(last_message.to).to eq(to)
      expect(last_message.body).to eq(body)
    end
  end
end
