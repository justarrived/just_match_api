# frozen_string_literal: true
require 'rails_helper'

RSpec.describe InvoiceMissingCompanyFrilansFinansIdNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:invoice) { mock_model Invoice }
  let(:job) { mock_model Job }

  it 'must work' do
    # Create an admin to send the email to
    user = FactoryGirl.create(:admin_user)

    allow(AdminMailer).to receive(:invoice_missing_company_frilans_finans_id_email).
      and_return(mailer)

    described_class.call(invoice: invoice, job: job)

    mailer_args = { user: user, invoice: invoice, job: job }
    expect(AdminMailer).to have_received(
      :invoice_missing_company_frilans_finans_id_email
    ).with(mailer_args)
  end
end
