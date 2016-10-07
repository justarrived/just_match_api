module InvalidCredentials
  INVALID_CREDENTIALS_CODE = :invalid_credentials

  def self.add(errors)
    errors.tap do |errors|
      errors.add(
        status: 401,
        code: INVALID_CREDENTIALS_CODE,
        detail: I18n.t('invalid_credentials')
      )
    end
  end
end
