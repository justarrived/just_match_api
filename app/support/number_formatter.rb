# frozen_string_literal: true
class NumberFormatter
  include ActionView::Helpers::NumberHelper # needed for #number_to_currency

  def to_currency(number, locale: I18n.locale, precision: 0, unit: 'SEK')
    return if number.blank?

    formatted_number = number_with_delimiter(
      number.round(precision),
      locale: locale
    )
    "#{formatted_number} #{unit}"
  end
end
