# frozen_string_literal: true
# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.welcome_email(user: User.first)
  end

  def reset_password_email
    user = User.first
    user.generate_one_time_token
    UserMailer.reset_password_email(user: user)
  end

  def changed_password_email
    I18n.locale = :en
    UserMailer.changed_password_email(user: User.first)
  end

  def magic_login_link_email
    user = User.first
    user.generate_one_time_token
    UserMailer.magic_login_link_email(user: user)
  end
end
