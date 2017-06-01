# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TexterJob do
  let(:job_args) { { from: 'from', to: 'to', body: 'body' } }

  it 'enqueues job' do
    expect do
      described_class.perform_later(**job_args)
    end.to have_enqueued_job(described_class).with(**job_args)
  end

  it 'enqueues job on default queue' do
    expect do
      described_class.perform_later(**job_args)
    end.to have_enqueued_job.on_queue('default')
  end
end
