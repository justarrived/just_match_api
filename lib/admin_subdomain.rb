# frozen_string_literal: true

class AdminSubdomain
  def self.matches?(request)
    request.subdomain.include?('admin')
  end
end
