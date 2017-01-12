# frozen_string_literal: true
require 'spec_helper'

RSpec.describe BaseNotifier do
  subject { described_class }

  it 'converts class name to underscored name' do
    expect(subject.underscored_name).to eq('base')
  end

  describe '#notify' do
    it 'returns true if nothing goes wrong' do
      success = described_class.notify { nil }
      expect(success).to eq(true)
    end

    it 'wraps block in passed locale' do
      start_locale = I18n.locale
      described_class.notify(locale: :ar) do
        expect(I18n.locale).to eq(:ar)
      end
      expect(I18n.locale).to eq(start_locale)
    end

    context 'Redis connection error' do
      it 'sends error notification' do
        allow(ErrorNotifier).to receive(:send).and_return(nil)
        described_class.notify { raise Redis::ConnectionError }
        expect(ErrorNotifier).to have_received(:send).once
      end

      it 'returns false' do
        success = described_class.notify { raise Redis::ConnectionError }
        expect(success).to eq(false)
      end
    end
  end
end
