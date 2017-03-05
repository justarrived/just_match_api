# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include HttpBasicAdminAuthenticator

  protect_from_forgery with: :exception

  def append_info_to_payload(payload)
    super
    payload[:user_id] = current_user.try(:id)
    payload[:host] = request.host
    payload[:source_ip] = request.remote_ip
    payload[:locale] = I18n.locale
  end

  def set_admin_locale
    I18n.locale = :en
  end
end
