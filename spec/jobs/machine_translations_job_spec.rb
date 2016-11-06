# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MachineTranslationsJob do
  let(:translation) { FactoryGirl.create(:job_translation) }
  let(:job_args) { { translation: translation } }

  it 'calls CreateMachineTranslationsService' do
    allow(CreateMachineTranslationsService).to receive(:call)
    described_class.perform_now(**job_args)
    expect(CreateMachineTranslationsService).to have_received(:call)
  end

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
