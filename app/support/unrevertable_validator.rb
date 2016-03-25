# frozen_string_literal: true
class UnrevertableValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value_changed = record.public_send("#{attribute}_changed?")
    return unless value_changed && value == false

    record.errors.add(attribute, error_message)
  end

  private

  def error_message
    options.fetch(:message, I18n.t('errors.validators.unrevertable'))
  end
end
