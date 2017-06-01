# frozen_string_literal: true

module NoSuchToken
  NO_SUCH_TOKEN = :no_such_token

  def self.add(errors = JsonApiErrors.new)
    errors.tap do |errs|
      errs.add(
        status: 401,
        code: NO_SUCH_TOKEN,
        detail: I18n.t('not_logged_in_error')
      )
    end
  end
end
