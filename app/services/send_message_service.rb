# frozen_string_literal: true

class SendMessageService
  class SMSBodyRequiredError < StandardError; end

  attr_reader :body, :subject

  def initialize(body: '', subject: '', data: {})
    data = data.symbolize_keys

    @body = format_string(body, data)
    @subject = format_string(subject, data)
  end

  def send_sms(to:, from: AppSecrets.twilio_number)
    raise SMSBodyRequiredError if body.empty?

    TexterJob.perform_later(
      from: PhoneNumber.normalize(from),
      to: PhoneNumber.normalize(to),
      body: body
    )

    nil
  end

  def send_email(to:, from: ApplicationMailer::DEFAULT_SUPPORT_EMAIL)
    envelope = ActionMailer::Base.mail(
      from: EmailAddress.normalize(from),
      to: EmailAddress.normalize(to),
      subject: subject,
      body: body
    )
    BaseNotifier.dispatch(envelope)

    nil
  end

  def format_string(string, data)
    (string || '') % data # can raise KeyError
  end
end
