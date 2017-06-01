# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: NO_REPLY_EMAIL

  def welcome_email(user:)
    @user_name = user.first_name

    utm_campaign = 'welcome_user'
    @faqs_url = frontend_mail_url(:faqs, utm_campaign: utm_campaign)
    @login_url = frontend_mail_url(:login, utm_campaign: utm_campaign)
    @cv_template_url = AppConfig.cv_template_url

    mail(to: user.contact_email, subject: I18n.t('mailer.welcome.subject'))
  end

  def reset_password_email(user:)
    @user_name = user.first_name
    token = user.one_time_token
    @reset_password_url = frontend_mail_url(
      :reset_password,
      token: token,
      utm_campaign: 'reset_password'
    )
    @support_email = AppConfig.support_email

    subject = I18n.t('mailer.reset_password.subject')
    mail(to: user.contact_email, subject: subject)
  end

  def changed_password_email(user:)
    @user_name = user.first_name

    subject = I18n.t('mailer.changed_password.subject')
    mail(to: user.contact_email, subject: subject)
  end

  def magic_login_link_email(user:)
    @magic_login_url = frontend_mail_url(
      :magic_login_link,
      token: user.one_time_token,
      utm_campaign: 'magic_login_link'
    )

    subject = I18n.t('mailer.magic_login_link.subject')
    mail(to: user.contact_email, subject: subject)
  end
end
