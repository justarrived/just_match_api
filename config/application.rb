# frozen_string_literal: true
require File.expand_path('../boot', __FILE__)

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie' # Needed for Rails mailers
# require 'sprockets/railtie'
# require "rails/test_unit/railtie"

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
    config.i18n.fallbacks = {
      'fa_AF' => 'fa',
      'ps' => 'fa_AF',
      'ti' => 'ar'
    }
    config.i18n.load_path += Dir[
      Rails.root.join('config', 'locales', '**', '*.{rb,yml}')
    ]

    config.api_only = true

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.middleware.use Rack::Attack

    config.active_job.queue_adapter = :sidekiq

    config.middleware.insert_before ActionDispatch::Static, 'Rack::Cors', logger: -> { Rails.logger } do # rubocop:disable Metrics/LineLength
      allow do
        origins(*ENV.fetch('CORS_WHITELIST', '').split(',').map(&:strip))
        resource '/api/*',
                 headers: :any,
                 methods: [:get, :post, :delete, :put, :patch, :options, :head]
      end
    end

    # rubocop:disable Metrics/LineLength
    config.x.frilans_finans = ENV['FRILANS_FINANS_ACTIVE'] == 'true'
    config.x.validate_job_date_in_future_inactive = ENV['VALIDATE_JOB_DATE_IN_FUTURE_INACTIVE'] == 'true'
    config.x.promo_code = ENV['PROMO_CODE']
    config.x.send_sms_notifications = ENV.fetch('SEND_SMS_NOTIFICATIONS', 'true') == 'true'
    config.x.validate_swedish_ssn = true
    config.x.active_analytics_tracking = ENV['ACTIVE_ANALYTICS_TRACKING'] == 'true'
    # rubocop:enable Metrics/LineLength

    config.paperclip_defaults = {
      storage: :fog,
      fog_credentials: {
        provider: 'Local',
        local_root: "#{Rails.root}/public"
      },
      fog_directory: '',
      fog_host: 'localhost'
    }
  end
end
