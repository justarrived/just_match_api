# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BaseNotifier do
  let(:mailer) { Struct.new(:deliver_now, :deliver_later).new }
  let(:error_mailer) do
    Class.new do
      def deliver_later
        raise Redis::ConnectionError
      end

      def deliver_now; end
    end.new
  end
  subject { described_class }

  it 'converts class name to underscored name' do
    expect(subject.underscored_name).to eq('base')
  end

  describe '#dispatch' do
    context 'ignored notification' do
      it 'does *not* yield to block if notification is ignored' do
        fake_user_klass = Class.new do
          def ignored_notification?(_); true; end
        end

        expect do
          described_class.dispatch(error_mailer, user: fake_user_klass.new)
        end.not_to raise_error
      end
    end

    context 'Redis connection error' do
      it 'sends error notification' do
        allow(ErrorNotifier).to receive(:send).and_return(nil)
        described_class.dispatch(error_mailer)
        expect(ErrorNotifier).to have_received(:send).once
      end

      it 're-sends with #deliver_now' do
        allow(error_mailer).to receive(:deliver_now).and_return(nil)
        described_class.dispatch(error_mailer)
        expect(error_mailer).to have_received(:deliver_now).once
      end
    end
  end
end
