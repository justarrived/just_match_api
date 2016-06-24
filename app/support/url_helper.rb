# frozen_string_literal: true
module URLHelper
  def self.starts_with_protocol?(url)
    url.starts_with?('http://') || url.starts_with?('https://')
  end

  def self.add_protocol(url)
    return url if starts_with_protocol?(url)

    'http://' + url
  end
end
