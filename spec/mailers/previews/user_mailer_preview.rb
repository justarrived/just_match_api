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
    UserMailer.changed_password_email(user: User.first)
  end

  def magic_login_link_email
    user = User.first
    user.generate_one_time_token
    UserMailer.magic_login_link_email(user: user)
  end

  def full_anonymization_queued_email
    UserMailer.full_anonymization_queued_email(
      user: User.first,
      anonymization_date: Date.new(2018, 1, 1)
    )
  end

  def partial_anonymization_queued_email
    UserMailer.partial_anonymization_queued_email(
      user: User.first,
      last_application_date: Date.new(2018, 1, 1),
      partial_anonymization_date: Date.new(2018, 7, 7),
      anonymization_date: Date.new(2020, 1, 1)
    )
  end

  def anonymization_performed_confirmation_email
    UserMailer.anonymization_performed_confirmation_email(email: User.first.email)
  end
end
