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
    let(:exception) do
      raised_error = nil
      begin
        raise StandardError, 'error message'
      rescue StandardError => e
        raised_error = e
      end
      raised_error
    end

    subject! do
      described_class.send(
        message,
        exception: exception,
        context: context,
        client: notify_client
      )
    end

    it 'sends' do
      error_context = notify_client.last[:context]
      expect(error_context[:name]).to eq(name)
      expect(error_context[:reraised_exception]).to eq(true)
      expect(error_context[:error_class]).to eq('StandardError')
      expect(error_context[:error_message]).to eq('error message')
    end
  end
end
