# frozen_string_literal: true

require 'read_static_faq'

class StaticFAQ
  STATIC_FAQ = ReadStaticFAQ.call.freeze

  def self.get(locale: nil)
    return STATIC_FAQ if locale.nil?

    STATIC_FAQ.fetch(locale.to_s)
  end
end
