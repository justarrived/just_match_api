# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobTexter do
  let(:last_name) { 'Doe' }
  let(:user) { FactoryGirl.build(:user, last_name: last_name) }
  let(:job_name) { 'A job name' }
  let(:job) { FactoryGirl.build(:job, name: job_name) }
  let(:job_user) { FactoryGirl.build(:job_user, job: job, user: user) }

  before(:each) do
    allow(AppSecrets).to receive(:twilio_account_sid).and_return('notsosecret')
    allow(AppSecrets).to receive(:twilio_auth_token).and_return('notsosecret')
  end

  describe '#applicant_accepted_text' do
    let!(:text) do
      described_class.applicant_accepted_text(job_user: job_user).deliver_now
    end
    let(:last_message_body) { FakeSMS.messages.last.body }

    it 'renders the job name' do
      expect(last_message_body).to match(job_name)
    end

    it 'renders the max confirmation time' do
      expect(last_message_body).to match(job_name)
    end

    it 'renders the frontend URL for the job' do
      url = FrontendRouter.draw(:job_user, job_id: job.id)
      expect(last_message_body).to match(url)
    end
  end
end
