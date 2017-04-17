# frozen_string_literal: true
class SwedishMunicipalityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value_changed = record.public_send("#{attribute}_changed?")
    return unless value_changed
    return if value.blank?
    return if Arbetsformedlingen::MunicipalityCode.valid?(value)

    message = options.fetch(:message) do
      I18n.t('errors.validators.swedish_municipality')
    end
    record.errors.add(attribute, message)
  end
end
