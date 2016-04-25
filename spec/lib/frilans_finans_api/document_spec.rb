# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FrilansFinansApi::Document do
  context 'collection' do
    subject do
      json = FrilansFinansApi::FixtureClient.new.read(:professions)
      described_class.new(json)
    end

    it 'is a collection' do
      expect(subject.collection?).to eq(true)
    end

    it 'can return #next_page_link' do
      expected = 'https://frilansfinans.se/api/professions?page=2'
      expect(subject.next_page_link).to eq(expected)
    end

    it 'can return #current_page' do
      expect(subject.current_page).to eq(1)
    end

    it 'can return #per_page' do
      expect(subject.per_page).to eq(10)
    end

    it 'can return #total_pages' do
      expect(subject.total_pages).to eq(331)
    end

    it 'can return #total' do
      expect(subject.total).to eq(1066)
    end

    it 'can return #count' do
      expect(subject.count).to eq(10)
    end

    it 'can return #resources' do
      expect(subject.resources.first).to be_a(FrilansFinansApi::Resource)
      # Assumes that professions fixture has 10 resources..
      expect(subject.resources.length).to eq(10)
    end
  end

  context 'single' do
    subject do
      json = FrilansFinansApi::FixtureClient.new.read(:profession)
      described_class.new(json)
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
