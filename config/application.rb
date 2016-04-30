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
    # ps    - Pushto [partial Rails translation locally]
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

    config.middleware.insert_before 0, 'Rack::Cors' do
      allow do
        origins '*'
        resource '*',
                 headers: :any,
                 methods: [:get, :post, :delete, :put, :patch, :options, :head]
      end
    end

    config.x.frilans_finans = false
    config.x.frilans_finans_default_taxkey_id = ENV['FRILANS_FINANS_DEFAULT_TAXKEY_ID']
    config.x.validate_job_date_in_future_inactive = ENV['VALIDATE_JOB_DATE_IN_FUTURE_INACTIVE'] == 'true' # rubocop:disable Metrics/LineLength

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
