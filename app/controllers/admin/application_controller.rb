# frozen_string_literal: true
# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin

    def authenticate_admin
      authenticate_or_request_with_http_basic do |email, password|
        User.admins.find_by_credentials(email: email, password: password)
      end
    end

    def records_per_page
      params[:per_page] || 20
    end
  end
end
