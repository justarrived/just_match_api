# frozen_string_literal: true
module HttpBasicAdminAuthenticator
  module_function

  def authenticate_admin
    authenticate_or_request_with_http_basic do |email, password|
      User.admins.find_by_credentials(email: email, password: password)
    end
  end
end
