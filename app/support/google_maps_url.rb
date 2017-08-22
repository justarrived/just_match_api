# frozen_string_literal: true

class GoogleMapsUrl
  BASE_URL = 'https://maps.google.com/?q='

  def self.build(address)
    BASE_URL + CGI.escape(address) if address
  end
end
