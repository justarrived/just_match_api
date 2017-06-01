# frozen_string_literal: true

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value_changed = record.public_send("#{attribute}_changed?")
    return unless value_changed
    return if value.blank?
    return if valid_url?(value)

    message = options.fetch(:message) { I18n.t('errors.validators.url') }
    record.errors.add(attribute, message)
  end

  def valid_url?(url)
    uri = URI.parse(url)
    return false unless uri.absolute?

    true
  rescue URI::InvalidURIError => _e
    false
  end
end
