# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FailedToActivateInvoiceNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:ff_invoice) { mock_model FrilansFinansInvoice }

  it 'must work' do
    # Create an admin to send the email to
    user = FactoryGirl.create(:admin_user)

    allow(AdminMailer).to receive(:failed_to_activate_invoice_email).
      and_return(mailer)

    described_class.call(ff_invoice: ff_invoice)

    mailer_args = { user: user, ff_invoice: ff_invoice }
    expect(AdminMailer).to have_received(
      :failed_to_activate_invoice_email
    ).with(mailer_args)
  end
end
