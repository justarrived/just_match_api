# frozen_string_literal: true

class MessageUser
  def self.call(type:, user:, template:, subject: nil, data: {})
    new(type, user, template, subject, data).call do |formatted_subject, message|
      yield(formatted_subject, message) if block_given?
    end
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
      yield(subject, message) if block_given?
    rescue KeyError => e
      return { success: false, message: "Error: '#{e.message}'" }
    end

    send_sms(@user.phone, message) if @user.phone?
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

    envelope = ActionMailer::Base.mail(
      from: ApplicationMailer::DEFAULT_SUPPORT_EMAIL,
      to: email,
      subject: subject,
      body: message
    )
    BaseNotifier.dispatch(envelope)
  end

  def send_sms?
    @type == 'sms' || @type == 'both'
  end

  def send_email?
    @type == 'email' || @type == 'both'
  end
end
