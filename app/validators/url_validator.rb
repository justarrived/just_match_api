# frozen_string_literal: true

require 'absolute_url'

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value_changed = record.public_send("#{attribute}_changed?")
    return unless value_changed
    return if value.blank?
    return if AbsoluteUrl.valid?(value)

    message = options.fetch(:message) { I18n.t('errors.validators.url') }
    record.errors.add(attribute, message)
  end
end
