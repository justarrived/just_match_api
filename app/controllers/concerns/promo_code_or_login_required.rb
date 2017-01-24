# frozen_string_literal: true
module PromoCodeOrLoginRequired
  PROMO_CODE_OR_LOGIN_REQUIRED_CODE = :promo_code_or_login_required

  def self.add(errors = JsonApiErrors.new)
    errors.tap do |errs|
      errs.add(
        status: 401,
        code: PROMO_CODE_OR_LOGIN_REQUIRED_CODE,
        detail: I18n.t('promo_code_required')
      )
    end
  end
end
