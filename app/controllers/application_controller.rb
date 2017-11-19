# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include HttpBasicAdminAuthenticator

  protect_from_forgery with: :exception

  before_action :set_admin_locale

  def append_info_to_payload(payload)
    super
    payload[:host] = request.host
    payload[:source_ip] = request.remote_ip
    payload[:locale] = I18n.locale
  end

  def set_admin_locale
    I18n.locale = params[:locale] || admin_locale || I18n.default_locale # rubocop:disable Metrics/LineLength
  end

  def default_url_options(_options = {})
    { locale: I18n.locale }
  end

  def admin_locale
    current_active_admin_user&.locale
  end
end
