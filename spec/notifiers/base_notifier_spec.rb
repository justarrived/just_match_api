# frozen_string_literal: true
require 'spec_helper'

RSpec.describe BaseNotifier do
  let(:mailer) { Struct.new(:deliver_now, :deliver_later).new }
  subject { described_class }

  it 'converts class name to underscored name' do
    expect(subject.underscored_name).to eq('base')
  end

  describe '#notify' do
    it 'wraps block in passed locale' do
      start_locale = I18n.locale
      described_class.notify(locale: :ar) do
        expect(I18n.locale).to eq(:ar)
        mailer
      end
      expect(I18n.locale).to eq(start_locale)
    end

    context 'Redis connection error' do
      let(:error_mailer) do
        Class.new do
          def deliver_later
            raise Redis::ConnectionError
          end

          def deliver_now; end
        end.new
      end

      it 'sends error notification' do
        allow(ErrorNotifier).to receive(:send).and_return(nil)
        described_class.notify { error_mailer }
        expect(ErrorNotifier).to have_received(:send).once
      end

      it 're-sends with #deliver_now' do
        allow(error_mailer).to receive(:deliver_now).and_return(nil)
        described_class.notify { error_mailer }
        expect(error_mailer).to have_received(:deliver_now).once
      end
    end
  end
end
