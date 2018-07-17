# frozen_string_literal: true

class I18nEmailContent
  def initialize(default_locale: I18n.default_locale)
    @default_locale = default_locale
    @locales = {}
  end

  def add(locale:, subject:, body:)
    @locales[locale.to_sym] = { subject: subject, body: body }
  end

  def subject(locale)
    for_locale(locale).fetch(:subject)
  end

  def body(locale)
    for_locale(locale).fetch(:body)
  end

  def for_locale(locale)
    @locales.fetch(locale.to_sym) do
      @locales.fetch(@default_locale.to_sym)
    end
  end

  def from_h(hash)
    @locales = hash
  end

  def to_h
    @locales
  end
end
