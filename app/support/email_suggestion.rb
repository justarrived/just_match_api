# frozen_string_literal: true
class EmailSuggestion
  DOMAINS = [
    'yahoo.com', 'google.com', 'hotmail.com', 'gmail.com', 'me.com', 'aol.com',
    'mac.com', 'live.com', 'comcast.net', 'googlemail.com', 'msn.com', 'hotmail.co.uk',
    'yahoo.co.uk', 'facebook.com', 'verizon.net', 'sbcglobal.net', 'att.net', 'gmx.com',
    'mail.com', 'outlook.com'
  ].freeze

  TOP_LEVEL_DOMAINS = [
    'co.uk', 'com', 'net', 'org', 'info', 'edu', 'se', 'eu'
  ].freeze

  def self.call(email)
    mailcheck = Mailcheck.new(domains: DOMAINS, top_level_domains: TOP_LEVEL_DOMAINS)
    suggestion = mailcheck.suggest(email)
    return suggestion if suggestion
    {}
  end
end
