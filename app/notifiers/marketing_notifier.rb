# frozen_string_literal: true

class MarketingNotifier < BaseNotifier
  def self.call(user:, i18n_email_content:)
    locale = user.locale

    envelope = ApplicationMailer.marketing_email(
      user: user,
      subject: i18n_email_content.subject(locale),
      body: i18n_email_content.body(locale)
    )
    dispatch(envelope, user: user)
  end
end
