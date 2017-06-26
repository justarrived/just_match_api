# frozen_string_literal: true

require_relative 'app_env'

class AppSecrets
  def self.env
    @env ||= default_env
  end

  def self.env=(env)
    @env = AppEnv.new(env: env)
  end

  def self.default_env
    @env = AppEnv.new
  end

  def self.document_parser_auth_token
    env['DOCUMENT_PARSER_AUTH_TOKEN']
  end

  def self.welcome_app_client_key
    env['WELCOME_APP_CLIENT_KEY']
  end

  def self.linkedin_sync_key
    env['LINKEDIN_SYNC_KEY']
  end

  def self.arbetsformedlingen_customer_id
    env['ARBETSFORMEDLINGEN_CUSTOMER_ID']
  end

  def self.arbetsformedlingen_admin_email
    env['ARBETSFORMEDLINGEN_ADMIN_EMAIL']
  end

  def self.incoming_email_key
    env['INCOMING_EMAIL_KEY']
  end

  def self.incoming_sms_key
    env['INCOMING_SMS_KEY']
  end

  def self.skylight_authentication
    env['SKYLIGHT_AUTHENTICATION']
  end

  def self.blazer_database_url
    env['BLAZER_DATABASE_URL']
  end

  def self.airbrake_project_id
    env['AIRBRAKE_PROJECT_ID']
  end

  def self.airbrake_api_key
    env['AIRBRAKE_API_KEY']
  end

  def self.sendgrid_password
    env['SENDGRID_PASSWORD']
  end

  def self.sendgrid_username
    env['SENDGRID_USERNAME']
  end

  def self.aws_access_key_id
    env['AWS_ACCESS_KEY_ID']
  end

  def self.aws_secret_access_key
    env['AWS_SECRET_ACCESS_KEY']
  end

  def self.new_relic_license_key
    env['NEW_RELIC_LICENSE_KEY']
  end

  def self.just_match_database_password
    env['JUST_MATCH_DATABASE_PASSWORD']
  end

  def self.mapbox_access_token
    env['MAPBOX_ACCESS_TOKEN']
  end

  def self.google_translate_api_key
    env['GOOGLE_TRANSLATE_API_KEY']
  end

  def self.google_maps_api_token
    env['GOOGLE_MAPS_API_TOKEN']
  end

  def self.frilans_finans_client_id
    env['FRILANS_FINANS_CLIENT_ID']
  end

  def self.frilans_finans_client_secret
    env['FRILANS_FINANS_CLIENT_SECRET']
  end

  def self.twilio_account_sid
    env['TWILIO_ACCOUNT_SID']
  end

  def self.twilio_auth_token
    env['TWILIO_AUTH_TOKEN']
  end

  def self.twilio_number
    env['TWILIO_NUMBER']
  end
end
