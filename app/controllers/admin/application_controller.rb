# frozen_string_literal: true
# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    include HttpBasicAdminAuthenticator

    before_action :authenticate_admin
    before_action :set_en_locale

    DEFAULT_RECORDS_PER_PAGE = 20

    def records_per_page
      params[:per_page] || DEFAULT_RECORDS_PER_PAGE
    end

    def set_en_locale
      I18n.locale = :en
    end
  end
end
