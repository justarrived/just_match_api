# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ErrorNotifier do
  let!(:notify_client) do
    Class.new do
      def initialize
        @notifications = []
      end

      def notify(message, context)
        @notifications << { message: message, context: context }
      end

      def last
        @notifications.last
      end
    end.new
  end

  describe '#send' do
    let(:message) { 'Error message' }
    let(:name) { 'Watman' }
    let(:context) { { name: name } }

    subject! { described_class.send(message, context: context, client: notify_client) }

    it 'sends' do
      expected = { message: message, context: context }

      expect(notify_client.last).to eq(expected)
    end
  end
end
