# frozen_string_literal: true
class TrueAfterValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    # return if value == true

    field = options.fetch(:field)

    unless record.public_send(field)
      record.errors.add(attribute, error_message(field))
    end
  end

  private

  def error_message(field)
    options.fetch(:message) do
      field_name = field.to_s.split('_').join(' ')
      I18n.t('errors.validators.true_after', field: field_name)
    end
  end
end
