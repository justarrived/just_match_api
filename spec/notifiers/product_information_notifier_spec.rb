# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductInformationNotifier, type: :mailer do
  let(:mailer) { Struct.new(:deliver_later).new(nil) }
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:subject) { 'email subject' }
  let(:body) { 'email body' }

  it 'must work' do
    content = I18nEmailContent.new
    content.add(locale: :en, subject: subject, body: body)

    allow(ApplicationMailer).to receive(:product_information_email).and_return(mailer)
    described_class.call(user: user, i18n_email_content: content)
    mailer_args = { user: user, subject: subject, body: body }
    expect(ApplicationMailer).to have_received(:product_information_email).with(mailer_args) # rubocop:disable Metrics/LineLength
  end
end
