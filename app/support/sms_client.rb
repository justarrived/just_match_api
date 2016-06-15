# frozen_string_literal: true
class SMSClient
  class MissingTwilioAccountSidError < ArgumentError; end
  class MissingTwilioAuthTokenError < ArgumentError; end

  cattr_accessor :client
  self.client = Twilio::REST::Client

  def initialize(account_sid: nil, auth_token: nil)
    sid = account_sid || ENV['TWILIO_ACCOUNT_SID'] || fail_with_missing_account_sid
    token = auth_token || ENV['TWILIO_AUTH_TOKEN'] || fail_with_missing_auth_token
    @client = client.new(sid, token)
  end

  def send_message(from:, to:, body:)
    @client.messages.create(from: from, to: to, body: body)
  end

  private

  def fail_with_missing_account_sid
    error_message = 'Provide account_sid argument or set env variable TWILIO_ACCOUNT_SID'
    fail(MissingTwilioAccountSidError, error_message)
  end

  def fail_with_missing_auth_token
    error_message = 'Provide auth_token argument or set env variable TWILIO_AUTH_TOKEN'
    fail(MissingTwilioAuthTokenError, error_message)
  end
end
