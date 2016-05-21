# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FrontendRoutesReader do
  subject { described_class.new }
  let(:base_url) { 'https://app.justarrived.se/' }

  it 'can read routes file' do
    expect(subject.routes).to be_a(Hash)
  end

  it 'has base url' do
    expect(subject.base_url).to include(base_url)
  end

  it 'returns route with base url' do
    expect(subject.draw(:login)).to include(base_url)
  end

  it 'returns login route' do
    result = subject.draw(:login)
    expected = "#{base_url}user/signin"
    expect(result).to eq(expected)
  end

  it 'returns faqs route' do
    result = subject.draw(:faqs)
    expected = "#{base_url}faq"
    expect(result).to eq(expected)
  end

  it 'returns route for a single job' do
    result = subject.draw(:job, id: 1)
    expected = "#{base_url}jobs/1"
    expect(result).to eq(expected)
  end

  it 'returns route for jobs' do
    result = subject.draw(:jobs)
    expected = "#{base_url}jobs"
    expect(result).to eq(expected)
  end

  it 'returns route for a job user' do
    result = subject.draw(:job_user, id: 1)
    expected = "#{base_url}arriver/1"
    expect(result).to eq(expected)
  end

  it 'returns reset password route' do
    token = 'asd'
    result = subject.draw(:reset_password, token: token)
    expected = "#{base_url}reset_password/#{token}"
    expect(result).to eq(expected)
  end
end

RSpec.describe FrontendRouter do
  subject { described_class }

  it 'is an instance of FrontendRoutesReader' do
    expect(described_class).to be_a(FrontendRoutesReader)
  end
end
