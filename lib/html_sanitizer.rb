# frozen_string_literal: true

require 'loofah'

class HTMLSanitizer
  def self.sanitize(html)
    Loofah.fragment(html).scrub!(:escape).to_s
  end
end
