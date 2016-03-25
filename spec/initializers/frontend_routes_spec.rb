# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FrontendRoutesReader do
  subject { described_class.new }

  it 'can read routes file' do
    expect(subject.routes).to be_a(Hash)
  end

  it 'has base url' do
    expect(subject.base_url).to include('https://justarrived.se/')
  end

  it 'returns route with base url' do
    expect(subject.fetch(:login)).to include('https://justarrived.se/')
  end

  it 'returns route' do
    result = subject.fetch(:login)
    expected = 'https://justarrived.se/login'
    expect(result).to eq(expected)
  end

  it 'returns formatted route' do
    token = 'asd'
    result = subject.fetch(:reset_password, token: token)
    expected = "https://justarrived.se/reset_password/#{token}"
    expect(result).to eq(expected)
  end
end

RSpec.describe FrontendRouter do
  subject { described_class }

  it 'is an instance of FrontendRoutesReader' do
    expect(described_class).to be_a(FrontendRoutesReader)
  end
end
