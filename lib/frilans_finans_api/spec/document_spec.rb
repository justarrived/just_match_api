# frozen_string_literal: true
require 'spec_helper'

RSpec.describe FrilansFinansApi::Document do
  describe 'status' do
    let(:response) { mock_httparty_response(code: 200) }

    subject do
      described_class.new(response)
    end

    it 'returns the documents http status' do
      expect(subject.status).to eq(200)
    end
  end

  describe 'error_status?' do
    let(:response) { mock_httparty_response(code: 422) }

    subject do
      described_class.new(response)
    end

    context 'response is error status' do
      it 'returns true' do
        expect(subject.error_status?).to eq(true)
      end
    end

    context 'response is *not* error status' do
      let(:response) { mock_httparty_response(code: 200) }

      it 'returns true' do
        expect(subject.error_status?).to eq(false)
      end
    end
  end

  describe 'uri' do
    let(:uri) { 'http://example.com' }
    let(:response) { mock_httparty_response(uri: uri) }

    subject do
      described_class.new(response)
    end

    it 'returns the documents http status' do
      expect(subject.uri).to eq(uri)
    end
  end

  context 'collection' do
    let(:response) do
      json = FrilansFinansApi::FixtureClient.new.read(:professions)
      mock_httparty_response(body: json)
    end

    subject do
      described_class.new(response)
    end

    it 'is a collection' do
      expect(subject.collection?).to eq(true)
    end

    it 'can return #next_page_link' do
      expected = 'https://frilansfinans.se/api/professions?page%5Bnumber%5D=2'
      expect(subject.next_page_link).to eq(expected)
    end

    it 'can return #current_page' do
      expect(subject.current_page).to eq(1)
    end

    it 'can return #per_page' do
      expect(subject.per_page).to eq(25)
    end

    it 'can return #total_pages' do
      expect(subject.total_pages).to eq(331)
    end

    it 'can return #total' do
      expect(subject.total).to eq(1066)
    end

    it 'can return #count' do
      expect(subject.count).to eq(1066)
    end

    it 'can return #resources' do
      expect(subject.resources.first).to be_a(FrilansFinansApi::Resource)
      # Assumes that professions fixture has 10 resources..
      expect(subject.resources.length).to eq(10)
    end
  end

  context 'single' do
    let(:response) do
      json = FrilansFinansApi::FixtureClient.new.read(:profession)
      mock_httparty_response(body: json)
    end

    subject do
      described_class.new(response)
    end

    it 'is a collection' do
      expect(subject.collection?).to eq(false)
    end

    it 'can return #next_page_link nil' do
      expect(subject.next_page_link).to be_nil
    end

    it 'can return #current_page nil' do
      expect(subject.current_page).to be_nil
    end

    it 'can return #per_page nil' do
      expect(subject.per_page).to be_nil
    end

    it 'can return #total_pages nil' do
      expect(subject.total_pages).to be_nil
    end

    it 'can return #resources' do
      expect(subject.resources.length).to eq(1)
      expect(subject.resources.first).to be_a(FrilansFinansApi::Resource)
    end
  end
end
