# frozen_string_literal: true

module AdminHelpers
  class Link
    def self.query(field, id)
      '?' + CGI.escape("q[#{field}_eq]") + "=#{id}"
    end
  end
end
