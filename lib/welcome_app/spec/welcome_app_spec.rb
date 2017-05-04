# frozen_string_literal: true

require 'spec_helper'

RSpec.describe WelcomeApp do
  it 'has a version number' do
    expect(WelcomeApp::VERSION).not_to be nil
  end
end
