# frozen_string_literal: true
module LoginRequired
  LOGIN_REQUIRED_CODE = :login_required

  def self.add(errors = JsonApiErrors.new)
    errors.tap do |errs|
      errs.add(
        status: 401,
        code: LOGIN_REQUIRED_CODE,
        detail: I18n.t('not_logged_in_error')
      )
    end
  end
end
