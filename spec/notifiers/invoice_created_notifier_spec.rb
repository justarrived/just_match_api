# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceCreatedNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:job) { mock_model Job, owner: owner, accepted_applicant: user }
  let(:user) { FactoryGirl.build(:user) }
  let(:owner) { FactoryGirl.build(:user) }

  it 'must work' do
    allow(InvoiceMailer).to receive(:invoice_created_email).and_return(mailer)
    InvoiceCreatedNotifier.call(job: job, user: user)
    mailer_args = { job: job, user: user, owner: job.owner }
    expect(InvoiceMailer).to have_received(:invoice_created_email).
      with(mailer_args)
  end
end
