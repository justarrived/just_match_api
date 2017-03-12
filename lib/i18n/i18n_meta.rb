# frozen_string_literal: true
class I18nMeta
  META = {
    'fa_AF' => { direction: :rtl, fallbacks: %w(fa en) },
    'ps' => { direction: :rtl, fallbacks: %w(fa_AF fa en) },
    'fa' => { direction: :rtl, fallbacks: %w(en) },
    'ti' => { direction: :ltr, fallbacks: %w(en) },
    'en' => { direction: :ltr, fallbacks: %w(sv) },
    'sv' => { direction: :ltr, fallbacks: %w(en) },
    'ku' => { direction: :rtl, fallbacks: %w(en) },
    'ar' => { direction: :rtl, fallbacks: %w(en) }
  }.freeze

  def self.meta(locale)
    META.fetch(locale.to_s) { { direction: :ltr, fallbacks: %w(en) } }
  end

  def self.direction(locale)
    meta(locale).fetch(:direction)
  end

  def self.align(locale)
    direction = direction(locale)
    case direction
    when :ltr then 'left'
    when :rtl then 'right'
    else
      fail "Unknown direction: '#{direction}'"
    end
  end

  def self.ltr?(locale)
    direction(locale) == :ltr
  end

  def self.rtl?(locale)
    direction(locale) == :rtl
  end

  def self.fallbacks(locale)
    meta(locale).fetch(:fallbacks)
  end

  def self.fallbacks_hash
    META.map { |locale, meta| [locale, meta.fetch(:fallbacks)] }.to_h
  end
end
