# frozen_string_literal: true

require 'spec_helper'

require_relative '../../config/version'

RSpec.describe JustMatch do
  it 'has VERSION' do
    expect(JustMatch::VERSION).to be_a(String)
  end

  it 'has MAJOR_VERSION' do
    expect(JustMatch::MAJOR_VERSION).to be_a(Integer)
  end

  it 'has MINOR_VERSION' do
    expect(JustMatch::MINOR_VERSION).to be_a(Integer)
  end

  it 'has PATCH_VERSION' do
    expect(JustMatch::PATCH_VERSION).to be_a(Integer)
  end
end
