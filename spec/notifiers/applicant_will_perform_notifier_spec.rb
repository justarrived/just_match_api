# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApplicantWillPerformNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: owner }
  let(:user) { FactoryGirl.build(:user) }
  let(:owner) { FactoryGirl.build(:user) }

  it 'must work' do
    allow(UserMailer).to receive(:applicant_will_perform_email).and_return(mailer)
    described_class.call(job: job, user: user)
    mailer_args = { job: job, user: user, owner: job.owner }
    expect(UserMailer).to have_received(:applicant_will_perform_email).with(mailer_args)
  end
end
