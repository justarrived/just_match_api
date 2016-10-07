module LoginRequired
  LOGIN_REQUIRED_CODE = :login_required

  def self.add(errors)
    errors.tap do |errors|
      errors.add(
        status: 401,
        code: LOGIN_REQUIRED_CODE,
        detail: I18n.t('not_logged_in_error')
      )
    end
  end
end
