# frozen_string_literal: true
class UserMailer < ApplicationMailer
  def welcome_email(user:)
    @user_name = user.name

    @faqs_url = FrontendRouter.draw(:faqs)
    @login_url = FrontendRouter.draw(:login)

    mail(to: user.email, subject: I18n.t('mailer.welcome.subject'))
  end

  def reset_password_email(user:)
    @user_name = user.first_name
    token = user.one_time_token
    @reset_password_url = FrontendRouter.draw(:reset_password, token: token)

    subject = I18n.t('mailer.reset_password.subject')
    mail(to: user.email, subject: subject)
  end

  def changed_password_email(user:)
    @user_name = user.first_name

    subject = I18n.t('mailer.changed_password.subject')
    mail(to: user.email, subject: subject)
  end

  def magic_login_link_email(user:)
    @magic_login_url = FrontendRouter.draw(:magic_login_link, token: user.one_time_token)

    subject = I18n.t('mailer.magic_login_link.subject')
    mail(to: user.email, subject: subject)
  end
end
