# frozen_string_literal: true

module NotFound
  NOT_FOUND_CODE = :not_found

  def self.add(errors = JsonApiErrors.new)
    errors.tap do |errs|
      errs.add(
        status: 404,
        code: NOT_FOUND_CODE,
        detail: I18n.t('record_not_found')
      )
    end
  end
end
