# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ContactNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:contact) { Contact.new }

  it 'must work' do
    allow(ContactMailer).to receive(:contact_email).and_return(mailer)
    described_class.call(contact: contact)
    mailer_args = { name: nil, email: nil, body: nil }
    expect(ContactMailer).to have_received(:contact_email).with(mailer_args)
  end
end
