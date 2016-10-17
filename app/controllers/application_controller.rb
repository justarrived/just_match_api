# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include HttpBasicAdminAuthenticator

  protect_from_forgery with: :exception

  def set_admin_locale
    I18n.locale = :en
  end
end
