# frozen_string_literal: true
class EmailValidator < ActiveModel::EachValidator
  EMAIL_REGEX = /\A.+@.+\..+\z/

  def validate_each(record, attribute, value)
    value_changed = record.public_send("#{attribute}_changed?")
    return unless value_changed
    return if value.match?(EMAIL_REGEX)

    message = options.fetch(:message) { I18n.t('errors.validators.email') }
    record.errors.add(attribute, message)
  end
end
