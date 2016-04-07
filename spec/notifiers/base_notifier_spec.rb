# frozen_string_literal: true
require 'spec_helper'

RSpec.describe BaseNotifier do
  subject { described_class }

  it 'converts class name to underscored name' do
    expect(subject.underscored_name).to eq('base')
  end
end
