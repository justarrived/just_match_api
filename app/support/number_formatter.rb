# frozen_string_literal: true

class NumberFormatter
  include ActionView::Helpers::NumberHelper

  def to_delimited(number, locale: I18n.locale, precision: 0)
    number_with_delimiter(
      number.to_f.round(precision),
      locale: locale
    )
  end

  def to_unit(number, unit, locale: I18n.locale, precision: 0)
    return if number.blank?

    formatted_number = number_with_delimiter(
      number.to_f.round(precision),
      locale: locale
    )

    return "#{unit} #{formatted_number}" if I18nMeta.rtl?(locale)

    "#{formatted_number} #{unit}"
  end
end
