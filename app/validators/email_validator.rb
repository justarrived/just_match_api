# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value_changed = record.public_send("#{attribute}_changed?")
    return unless value_changed
    return if value.nil?
    return if EmailAddress.valid?(value)

    message = options.fetch(:message) { I18n.t('errors.validators.email') }
    record.errors.add(attribute, message)
  end
end
