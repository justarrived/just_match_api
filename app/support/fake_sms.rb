# frozen_string_literal: true

class FakeSMS
  Message = Struct.new(:from, :to, :body)

  cattr_accessor :messages
  self.messages = []

  def initialize(_account_sid, _auth_token); end

  def messages
    self
  end

  def create(from:, to:, body:)
    self.class.messages << Message.new(from, to, body)
  end
end
