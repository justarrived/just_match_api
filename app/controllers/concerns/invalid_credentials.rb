# frozen_string_literal: true
module InvalidCredentials
  INVALID_CREDENTIALS_CODE = :invalid_credentials

  def self.add(errors = JsonApiErrors.new)
    errors.tap do |errs|
      errs.add(
        status: 403,
        code: INVALID_CREDENTIALS_CODE,
        detail: I18n.t('invalid_credentials')
      )
    end
  end
end
