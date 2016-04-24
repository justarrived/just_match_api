# frozen_string_literal: true
require 'rails_helper'

RSpec.describe InvoiceFailedToConnectToFrilansFinansNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:invoice) { mock_model Invoice }

  it 'must work' do
    # Create an admin to send the email to
    user = FactoryGirl.create(:admin_user)

    allow(AdminMailer).to receive(:invoice_failed_to_connect_to_frilans_finans_email).
      and_return(mailer)

    described_class.call(invoice: invoice)

    mailer_args = { user: user, invoice: invoice }
    expect(AdminMailer).to have_received(
      :invoice_failed_to_connect_to_frilans_finans_email
    ).with(mailer_args)
  end
end
