# frozen_string_literal: true

require 'spec_helper'

require 'google_calendar_url'

RSpec.describe GoogleCalendarUrl do
  let(:start_time) { Time.new(2016, 1, 1, 1, 1, 1, '+01:00') }
  let(:start_time_iso8601) { '20160101T000101Z' }

  describe '#build' do
    let(:name) { 'Jacob B' }
    let(:description) { 'A fancy description.. ' * 150 }
    let(:location) { 'Stockholm, 11855, Sweden' }

    subject do
      described_class.build(
        name: name,
        description: description,
        location: location,
        start_time: start_time,
        end_time: Time.new(2017, 1, 1, 1, 1, 1, '+01:00')
      )
    end

    it 'returns correct base URI' do
      uri = URI.parse(subject)
      query = uri.query

      expect(uri.absolute?).to eq(true)
      expect(uri.host).to eq('www.google.com')
      expect(uri.path).to eq('/calendar/render')
      expect(query).to include('action=TEMPLATE')
      expect(query).to include('sf=true')
      expect(query).to include('output=xml')
    end

    it 'returns correct name query param' do
      uri = URI.parse(subject)
      query = uri.query

      expect(query).to include("text=#{URI.encode(name)}")
    end

    it 'returns correct description query param (truncated to a 1000 characters)' do
      uri = URI.parse(subject)
      query = uri.query

      expected_description = URI.encode(description.truncate(1000))
      expect(query).to include("details=#{expected_description}")
    end

    it 'returns correct location query param' do
      uri = URI.parse(subject)
      query = uri.query

      expect(query).to include("location=#{URI.encode(location)}")
    end

    it 'returns dates query param' do
      uri = URI.parse(subject)
      query = uri.query

      end_date = '20170101T000101Z'
      dates = [start_time_iso8601, end_date].join('/')

      expect(query).to include("dates=#{dates}")
    end

    it 'returns dates query param even when the end date is nil' do
      uri = URI.parse(subject)
      query = uri.query

      dates = [start_time_iso8601, nil].join('/')

      expect(query).to include("dates=#{dates}")
    end
  end

  describe '#format_datetime' do
    it 'formats date as iso8601 (ish)' do
      expect(described_class.format_datetime(start_time)).to eq(start_time_iso8601)
    end
  end

  describe '#uri_encode' do
    let(:text) { 'Hello^' }
    let(:encoded_text) { 'Hello%5E' }
    subject(:uri) { described_class.uri_encode(text) }

    context 'when passed string' do
      it 'returns encoded string' do
        expect(uri).to eq(encoded_text)
      end
    end

    context 'when passed nil' do
      let(:text) { nil }
      let(:encoded_text) { '' }

      it 'returns empty string' do
        expect(uri).to eq(encoded_text)
      end
    end
  end
end
