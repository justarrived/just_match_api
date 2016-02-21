# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DashboardManifest do
  subject { described_class }

  it 'has DASHBOARDS constant' do
    expect(subject::DASHBOARDS).not_to be_nil
  end

  it 'has correct ROOT_DASHBOARD constant' do
    expect(subject::ROOT_DASHBOARD).to eq(:jobs)
  end
end
