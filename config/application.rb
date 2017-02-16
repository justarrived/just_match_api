# frozen_string_literal: true
require_relative 'boot'

require 'rails'

# Require JustMatch app specific config & secrets
require_relative 'app_env'
require_relative 'app_config'
require_relative 'app_secrets'

# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie' # Needed for Rails mailers
# require 'sprockets/railtie'
# require "rails/test_unit/railtie"

require_relative '../lib/middleware/catch_json_parse_errors'
require_relative '../lib/i18n/i18n_meta'

Bundler.require(*Rails.groups)

module JustMatch
  class Application < Rails::Application
    config.time_zone = 'Stockholm'

    config.i18n.default_locale = :en
    # en    - English
    # sv    - Swedish
    # ar    - Arabic
    # fa    - Persian (Farsi)
    # ku    - Kurdish [partial Rails translation locally]
    # ti    - Tigrinya [partial Rails translation locally]
    # fa_AF - Dari / Persian (Afghanistan) [partial Rails translation locally]
    # ps    - Pashto [partial Rails translation locally]
    config.i18n.available_locales = [:en, :sv, :ar, :fa, :ku, :ti, :fa_AF, :ps]
    config.i18n.fallbacks = I18nMeta.fallbacks_hash
    config.i18n.load_path += Dir[
      Rails.root.join('config', 'locales', '**', '*.{rb,yml}')
    ]

    # The admin interface is a local app and therefore we can't have the
    # project configured to be API only
    config.api_only = false

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.middleware.insert_before Rack::Head, CatchJsonParseErrors
    config.middleware.use Rack::Attack

    config.active_job.queue_adapter = :sidekiq

    config.middleware.insert_before ActionDispatch::Static, Rack::Cors, logger: -> { Rails.logger } do # rubocop:disable Metrics/LineLength
      allow do
        origins(*AppConfig.cors_whitelist)
        resource '/api/*',
                 headers: :any,
                 methods: [:get, :post, :delete, :put, :patch, :options, :head]
      end
    end

    # rubocop:disable Metrics/LineLength
    config.x.frilans_finans = AppConfig.frilans_finans_active?
    config.x.validate_job_date_in_future_inactive = AppConfig.validate_job_date_in_future_inactive?
    config.x.promo_code = AppConfig.promo_code
    config.x.send_sms_notifications = AppConfig.send_sms_notifications?
    config.x.validate_swedish_ssn = AppConfig.validate_swedish_ssn
    config.x.invoice_company_frilans_finans_id = AppConfig.invoice_company_frilans_finans_id
    # rubocop:enable Metrics/LineLength

    config.paperclip_defaults = {
      storage: :fog,
      fog_credentials: {
        provider: 'Local',
        local_root: Rails.root.join('public').to_s
      },
      fog_directory: '',
      fog_host: 'localhost'
    }
  end
end
