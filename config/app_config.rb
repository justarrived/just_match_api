# frozen_string_literal: true
require_relative 'app_env'

class AppConfig
  def self.env
    @env ||= default_env
  end

  def self.env=(env)
    @env = AppEnv.new(env: env)
  end

  def self.default_env
    @env = AppEnv.new
  end

  def self.default_mailer_url_host
    'api.justarrived.se'
  end

  def self.payslip_explain_url
    'http://justarrived.se/payslip/'
  end

  def self.cv_template_url
    'http://justarrived.se/assets/files/CV-template.docx'
  end

  def self.arbetsformedlingen_default_publisher_email
    env['ARBETSFORMEDLINGEN_DEFAULT_PUBLISHER_EMAIL']
  end

  def self.arbetsformedlingen_default_publisher_name
    env['ARBETSFORMEDLINGEN_DEFAULT_PUBLISHER_NAME']
  end

  # Application settings

  def self.allow_regular_users_to_create_jobs?
    truthy?(env['ALLOW_REGULAR_USERS_TO_CREATE_JOBS'])
  end

  def self.globally_ignored_notifications
    (env['GLOBALLY_IGNORED_NOTIFICATIONS'] || '').
      split(',').
      map { |name| name.strip.downcase }.
      compact
  end

  def self.new_job_request_email_recipients
    env.fetch('NEW_JOB_REQUEST_EMAIL_RECIPIENTS', '').split(',').
      map { |name| name.strip.downcase }.
      compact
  end

  def self.support_email
    env['DEFAULT_SUPPORT_EMAIL']
  end

  def self.managed_email_username
    env['MANAGED_EMAIL_USERNAME']
  end

  def self.managed_email_hostname
    env['MANAGED_EMAIL_HOSTNAME']
  end

  def self.invoice_company_frilans_finans_id
    env['INVOICE_COMPANY_FRILANS_FINANS_ID']
  end

  def self.linkedin_job_records_feed_limit
    Integer(env.fetch('LINKEDIN_JOB_RECORDS_FEED_LIMIT', 300))
  end

  def self.default_records_per_page
    Integer(env.fetch('DEFAULT_RECORDS_PER_PAGE', 10))
  end

  def self.default_max_records_per_page
    Integer(env.fetch('DEFAULT_MAX_RECORDS_PER_PAGE', 50))
  end

  def self.max_records_per_page
    env.fetch('MAX_RECORDS_PER_PAGE', 1000)
  end

  def self.frilans_finans_company_creator_user_id
    env['FRILANS_FINANS_COMPANY_CREATOR_USER_ID']
  end

  def self.frilans_finans_base_uri
    env['FRILANS_FINANS_BASE_URI']
  end

  def self.welcome_app_active?
    truthy?(env['WELCOME_APP_ACTIVE'])
  end

  def self.frilans_finans_active?
    truthy?(env['FRILANS_FINANS_ACTIVE'])
  end

  def self.validate_job_date_in_future_inactive?
    truthy?(env['VALIDATE_JOB_DATE_IN_FUTURE_INACTIVE'])
  end

  def self.cors_whitelist
    env.
      fetch('CORS_WHITELIST', '').
      split(',').
      map(&:strip)
  end

  def self.send_sms_notifications?
    truthy?(env.fetch('SEND_SMS_NOTIFICATIONS', true))
  end

  def self.app_host
    env.fetch('APP_HOST', 'https://api.justarrived.se')
  end

  def self.validate_swedish_ssn
    truthy?(env.fetch('VALIDATE_SWEDISH_SSN', true))
  end

  # Application config

  def self.aws_region
    env['AWS_REGION']
  end

  def self.s3_bucket_name
    env['S3_BUCKET_NAME']
  end

  def self.redis_url
    env.fetch('REDIS_URL', 'localhost')
  end

  def self.app_base_url
    env.fetch('APP_BASE_URL', 'https://api.justarrived.se')
  end

  def self.live_frilans_finans_seed?
    !!env.fetch('LIVE_FRILANS_FINANS_SEED', false)
  end

  # Application Server

  def self.rack_timeout
    Integer(env.fetch('RACK_TIMEOUT', 15)) # seconds
  end

  def self.db_pool
    env['DB_POOL']
  end

  def self.redis_timeout
    Integer(env.fetch('REDIS_TIMEOUT', 5))
  end

  def self.port
    env.fetch('PORT', 3000)
  end

  def self.max_threads
    Integer(env.fetch('MAX_THREADS', 2))
  end

  def self.web_concurrency
    Integer(env.fetch('WEB_CONCURRENCY', 2))
  end

  # Environment

  def self.rails_env
    env['RAILS_ENV']
  end

  def self.rack_env
    env.fetch('RACK_ENV', 'development')
  end

  def self.rails_log_to_stdout?
    truthy?(env['RAILS_LOG_TO_STDOUT'])
  end

  def self.rails_serve_static_files?
    truthy?(env['RAILS_SERVE_STATIC_FILES'])
  end

  # private

  def self.truthy?(value)
    [true, 'true', 'enabled', 'enable', 'yes', 'y'].include?(value)
  end
end
