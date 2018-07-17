# frozen_string_literal: true

require 'uri'

class AbsoluteUrl
  def self.valid?(url)
    uri = URI.parse(url)
    return false unless uri.absolute?

    true
  rescue URI::InvalidURIError => _e
    false
  end
end
