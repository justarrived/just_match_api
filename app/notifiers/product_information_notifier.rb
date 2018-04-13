# frozen_string_literal: true

class ProductInformationNotifier < BaseNotifier
  def self.call(user:, i18n_email_content:)
    locale = user.locale

    envelope = ApplicationMailer.product_information_email(
      user: user,
      subject: i18n_email_content.subject(locale),
      body: i18n_email_content.body(locale)
    )
    dispatch(envelope, user: user)
  end
end
