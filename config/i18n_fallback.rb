# frozen_string_literal: true
module I18nFallback
  I18N_FALLBACKS = {
    'fa_AF' => %w(fa en),
    'ps' => %w(fa_AF fa en),
    'fa' => %w(en),
    'ti' => %w(en),
    'en' => %w(sv),
    'sv' => %w(en),
    'ku' => %w(en),
    'ar' => %w(en)
  }.with_indifferent_access.freeze

  def self.get(locale)
    I18N_FALLBACKS.fetch(locale, [])
  end

  def self.to_h
    I18N_FALLBACKS
  end
end
