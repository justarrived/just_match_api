# frozen_string_literal: true
class UnrevertableValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value_changed = record.public_send("#{attribute}_changed?")
    return unless value_changed && value == false

    record.errors.add(attribute, error_message(record, attribute))
  end

  private

  def error_message(record, attribute)
    options.fetch(:message) do
      singular_model_name = record.class.model_name.singular
      field_name = I18n.t(
        "activerecord.attributes.#{singular_model_name}.#{attribute}",
        default: attribute.to_s.split('_').join(' ')
      ).downcase
      I18n.t('errors.validators.unrevertable', field: field_name)
    end
  end
end
