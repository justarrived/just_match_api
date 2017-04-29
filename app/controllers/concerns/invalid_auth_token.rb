# frozen_string_literal: true
module InvalidAuthToken
  INVALID_AUTH_TOKEN_CODE = :invalid_auth_token

  def self.add(errors = JsonApiErrors.new)
    errors.tap do |errs|
      errs.add(
        status: 401,
        code: INVALID_AUTH_TOKEN_CODE,
        detail: I18n.t('invalid_auth_token')
      )
    end
  end
end
