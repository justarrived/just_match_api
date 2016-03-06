# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApplicantWillPerformNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: nil }

  it 'must work' do
    allow(UserMailer).to receive(:applicant_will_perform_email).and_return(mailer)
    described_class.call(job: job, user: nil)
    expect(UserMailer).to have_received(:applicant_will_perform_email)
  end
end
