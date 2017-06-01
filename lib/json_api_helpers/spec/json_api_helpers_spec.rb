# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JsonApiHelpers do
  it 'has a major version number' do
    expect(JsonApiHelpers::MAJOR).not_to be nil
  end

  it 'has a minor version number' do
    expect(JsonApiHelpers::MINOR).not_to be nil
  end

  it 'has a patch version number' do
    expect(JsonApiHelpers::PATCH).not_to be nil
  end

  it 'has a version number' do
    expect(JsonApiHelpers::VERSION).not_to be nil
  end
end
