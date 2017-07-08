# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendMessageService do
  describe '#send_sms' do
    it 'calls TexterJob correctly' do
      allow(TexterJob).to receive(:perform_later).and_return(nil)

      service = described_class.new(body: 'Hi!')
      service.send_sms(to: '0735000001', from: '0735000001')
      texter_args = { from: '+46735000001', to: '+46735000001', body: 'Hi!' }
      expect(TexterJob).to have_received(:perform_later).with(texter_args)
    end

    it 'raises SMSBodyRequiredError if body is missing' do
      service = described_class.new
      expect do
        service.send_sms(to: 'asd')
      end.to raise_error(SendMessageService::SMSBodyRequiredError)
    end
  end

  describe '#send_email' do
    it 'works' do
      service = described_class.new(body: 'Hi!')
      result = service.send_email(to: 'wat@example.com')
      expect(result).to be_nil
    end
  end

  describe '#body' do
    it 'formats body' do
      service = described_class.new(body: '%<name>s!', data: { name: 'wat' })
      expect(service.body).to eq('wat!')
    end
  end

  describe '#subject' do
    it 'formats subject' do
      service = described_class.new(subject: '%<name>s!', data: { name: 'wat' })
      expect(service.subject).to eq('wat!')
    end
  end

  describe '#format_string' do
    [
      ['', {}, ''],
      [nil, {}, ''],
      [nil, { name: 'wat' }, ''],
      ['Hi', {}, 'Hi'],
      ['Hi ${name}', { name: 'buren' }, 'Hi ${name}'],
      # rubocop:disable Style/FormatStringToken
      ['Hi %{name}', { name: 'buren' }, 'Hi buren'],
      ['Hi %{name} (%{lang}ist)', { name: 'buren', lang: 'Ruby' }, 'Hi buren (Rubyist)'],
      # rubocop:enable Style/FormatStringToken
      ['Hi %<name>s', { name: 'buren' }, 'Hi buren']
    ].each do |test_data|
      string, data, expected = test_data

      it "returns correct string for string '#{string}', with data #{data}" do
        service = described_class.new
        expect(service.format_string(string, data)).to eq(expected)
      end
    end

    it 'raises KeyError when there are missing keys in the data' do
      service = described_class.new
      expect do
        service.format_string('Hi %<name>s (%<lang>sist)', {})
      end.to raise_error(KeyError)
    end
  end
end
