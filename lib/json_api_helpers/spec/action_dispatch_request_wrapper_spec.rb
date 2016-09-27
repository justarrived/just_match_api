# frozen_string_literal: true
require 'spec_helper'

RSpec.describe JsonApiHelpers::ActionDispatchRequestWrapper do
  let(:url) { 'http://example.com' }
  let(:name) { 'Watwoman' }
  let(:object) { OpenStruct.new(watman: name, base_url: url, path: '') }

  subject { described_class.new(object) }

  it 'delegates to passed object' do
    expect(subject.watman).to eq(name)
  end

  it 'delegates #request_url to passed object#original_url' do
    expect(subject.request_url).to eq(url)
  end
end
