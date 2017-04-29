# frozen_string_literal: true

require 'arbetsformedlingen/codes/drivers_license_code'

class SwedishDriversLicenseValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value_changed = record.public_send("#{attribute}_changed?")
    return unless value_changed
    return if value.blank?
    
    return if Arbetsformedlingen::DriversLicenseCode.valid?(value)

    message = options.fetch(:message) { I18n.t('errors.validators.drivers_license') }
    record.errors.add(attribute, message)
  end
end
