# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AskForJobInformationNotifier, type: :mailer do
  describe '::call' do
    let(:mailer) { Struct.new(:deliver_later).new(nil) }
    let(:job) do
      FactoryGirl.create(:job).tap do |j|
        j.skills = [FactoryGirl.create(:skill)]
      end
    end
    let(:job_user) { FactoryGirl.build(:job_user, job: job) }

    it 'sends email' do
      allow(JobMailer).to receive(:ask_for_information_email).and_return(mailer)
      described_class.call(job_user: job_user)
      mailer_args = { job: job, user: job_user.user, skills: job.skills }
      expect(JobMailer).to have_received(:ask_for_information_email).with(mailer_args)
    end
  end
end
