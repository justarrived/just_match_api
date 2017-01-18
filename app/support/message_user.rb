# frozen_string_literal: true
class MessageUser
  def self.call(type:, user:, template:, subject: nil, data: {})
    new(type, user, template, subject, data).call
  end

  def initialize(type, user, template, subject, data)
    @type = type
    @user = user
    @template = template
    @subject = subject
    @data = data.symbolize_keys
  end

  def call
    attributes = {}
    @user.attributes.each { |key, value| attributes[:"user_#{key}"] = value }
    attributes.merge!(@data)
    begin
      message = @template % attributes
      subject = @subject % attributes
    rescue KeyError => e
      return { success: false, message: "Error: '#{e.message}'" }
    end

    send_sms(@user.phone, message)
    send_email(@user.email, subject, message)

    { success: true, message: 'Sending message to user.' }
  end

  def send_sms(phone, message)
    return unless send_sms? && phone

    from = AppSecrets.twilio_number
    TexterJob.perform_later(from: from, to: phone, body: message)
  end

  def send_email(email, subject, message)
    return unless send_email?

    BaseNotifier.notify do
      ActionMailer::Base.mail(
        from: ApplicationMailer::NO_REPLY_EMAIL,
        to: email,
        subject: subject,
        body: message
      )
    end
  end

  def send_sms?
    @type == 'sms' || @type == 'both'
  end

  def send_email?
    @type == 'email' || @type == 'both'
  end
end
