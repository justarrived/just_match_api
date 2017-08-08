# frozen_string_literal: true

class MessageUserService
  def self.call(type:, user:, template:, subject: nil, data: {})
    new(type, user, template, subject, data).call do |formatted_subject, message|
      yield(formatted_subject, message) if block_given?
    end
  end

  attr_reader :subject, :body

  def initialize(type, user, template, subject, data)
    @type = type
    @data = data
    @user = user
    @template = template
    @subject = subject

    attributes = @user.attributes.
                 transform_keys { |key| "user_#{key}" }.
                 merge!(@data)

    @service = SendMessageService.new(body: template, subject: subject, data: attributes)
  rescue KeyError => e
    @key_error = true
    @key_error_message = "Error: '#{e.message}'"
  end

  def call
    return { success: false, message: @key_error_message } if key_error?

    send_sms
    send_email

    yield(@service.subject, @service.body) if block_given?

    { success: true, message: 'Sending message to user.' }
  end

  def send_sms
    phone = @user.phone
    return unless send_sms? && phone.present?

    @service.send_sms(to: phone)
  end

  def send_email
    email = @user.email
    return unless send_email? && email.present?

    @service.send_email(to: @user.email)
  end

  def key_error?
    !!@key_error
  end

  def send_sms?
    @type == 'sms' || @type == 'both'
  end

  def send_email?
    @type == 'email' || @type == 'both'
  end
end
