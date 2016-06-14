# frozen_string_literal: true
class TexterJob < ActiveJob::Base
  def perform(from:, to:, body:)
    ApplicationTexter.new(from: from, to: to, body: body).deliver_now
  end
end
