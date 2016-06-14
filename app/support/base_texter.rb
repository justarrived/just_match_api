# frozen_string_literal: true
class BaseTexter
  cattr_accessor :default_from

  def self.text(**args)
    new(**args)
  end

  def initialize(from: default_from, to:, body:)
    @from = from
    @to = to
    @body = body
  end

  def deliver_now
    client = SMSClient.new
    client.send_message(from: @from, to: @to, body: @body)
  end
end
