# frozen_string_literal: true
class LinkedinValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value_changed = record.public_send("#{attribute}_changed?")
    return unless value_changed
    return if value.blank?
    return if valid_linkedin_url?(value)

    message = options.fetch(:message) { I18n.t('errors.validators.linkedin_url') }
    record.errors.add(attribute, message)
  end

  def valid_linkedin_url?(url)
    return false unless includes_protocol?(url)
    return false unless url.include?('linkedin.com/')

    true
  end

  def includes_protocol?(url)
    url.include?('https://') || url.include?('http://')
  end
end
