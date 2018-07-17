# frozen_string_literal: true

module AdminHelpers
  class Link
    def self.query(field, id)
      # NOTE: Since ApplicationController#default_url_options adds a locale= params
      # we add & instead of ? to the URL
      '&' + CGI.escape("q[#{field}_eq]") + "=#{id}"
    end
  end
end
