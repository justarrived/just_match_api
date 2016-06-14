# frozen_string_literal: true
class ApplicationTexter < BaseTexter
  self.default_from = ENV.fetch('TWILIO_NUMBER')
end
