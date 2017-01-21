# frozen_string_literal: true
module Unauthorized
  UNAUTHORIZED_CODE = :unauthorized

  def self.add(errors = JsonApiErrors.new)
    errors.tap do |errs|
      errs.add(
        status: 401,
        code: UNAUTHORIZED_CODE,
        detail: I18n.t('errors.unauthorized')
      )
    end
  end
end
