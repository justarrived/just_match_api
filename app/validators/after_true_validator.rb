# frozen_string_literal: true
class AfterTrueValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    field = options.fetch(:field)

    unless record.public_send(field)
      record.errors.add(attribute, error_message(record, field))
    end
  end

  private

  def error_message(record, field)
    options.fetch(:message) do
      singular_model_name = record.class.model_name.singular
      field_name = I18n.t(
        "activerecord.attributes.#{singular_model_name}.#{field}",
        default: field.to_s.split('_').join(' ')
      ).downcase
      I18n.t('errors.validators.after_true', field: field_name)
    end
  end
end
