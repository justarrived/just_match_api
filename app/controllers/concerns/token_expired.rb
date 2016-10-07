module TokenExpired
  TOKEN_EXPIRED_CODE = :token_expired

  def self.add(errors)
    errors.tap do |errors|
      errors.add(
        status: 401,
        detail: I18n.t('token_expired_error'),
        code: TOKEN_EXPIRED_CODE
      )
    end
  end
end
