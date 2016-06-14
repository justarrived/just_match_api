# frozen_string_literal: true
class SMSClient
  cattr_accessor :client
  self.client = Twilio::REST::Client

  def initialize
    @client = client.new(
      ENV.fetch('TWILIO_ACCOUNT_SID'),
      ENV.fetch('TWILIO_AUTH_TOKEN')
    )
  end

  def send_message(from:, to:, body:)
    @client.messages.create(from: from, to: to, body: body)
  end
end
