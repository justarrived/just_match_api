# frozen_string_literal: true
class EmailSuggestion
  DOMAINS = [
    'yahoo.com', 'google.com', 'hotmail.com', 'gmail.com', 'me.com', 'aol.com',
    'mac.com', 'live.com', 'googlemail.com', 'msn.com', 'hotmail.co.uk',
    'yahoo.co.uk', 'facebook.com', 'outlook.com', 'justarrived.se', 'telia.se',
    'icloud.com', 'kth.se', 'lth.se', 'chalmers.se', 'yandex.com'
  ].freeze

  # Common top level domains globally
  GLOBAL_TOP_LEVEL_DOMAINS = [
    'co.uk', 'com', 'net', 'org', 'info', 'edu'
  ].freeze

  # Common top level domains in Sweden
  SE_DOMAINS = %w(se nu).freeze

  # All common top level domains (in the context of the current context of the app)
  TOP_LEVEL_DOMAINS = (GLOBAL_TOP_LEVEL_DOMAINS + SE_DOMAINS).freeze

  def self.call(email)
    mailcheck = Mailcheck.new(
      domains: DOMAINS,
      top_level_domains: TOP_LEVEL_DOMAINS
    )
    suggestion = mailcheck.suggest(email)
    return suggestion if suggestion
    {}
  end
end
