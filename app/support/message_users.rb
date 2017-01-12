# frozen_string_literal: true
class MessageUsers
  def self.call(type:, users:, template:, subject: nil)
    new(type, users, template, subject).call
  end

  def initialize(type, users, template, subject)
    @type = type
    @users = users
    @template = template
    @subject = subject
  end

  def call
    @users.each do |user|
      attributes = user.attributes.symbolize_keys
      begin
        message = @template % attributes
        subject = @subject % attributes
      rescue KeyError => e
        return { success: false, message: "Unknown key: '#{e.message}'" }
      end

      send_sms(user.phone, message)
      send_email(user.email, subject, message)
    end

    { success: true, message: "Sending #{type_name} to #{@users.length} user(s)." }
  end

  def send_sms(phone, message)
    return unless send_sms? && phone

    from = AppSecrets.twilio_number
    TexterJob.perform_later(from: from, to: phone, body: message)
  end

  def send_email(email, subject, message)
    return unless send_email?

    ActionMailer::Base.mail(
      from: ApplicationMailer::NO_REPLY_EMAIL,
      to: email,
      subject: subject,
      body: message
    ).deliver_later
  end

  def send_sms?
    @type == 'sms' || @type == 'both'
  end

  def send_email?
    @type == 'email' || @type == 'both'
  end

  def type_name
    return 'both sms and email' if @type == 'both'
    @type
  end
end
