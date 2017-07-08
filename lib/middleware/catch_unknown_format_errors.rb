# frozen_string_literal: true

class CatchUnknownFormatErrors
  HTTP_STATUS = 406

  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue ActionController::UnknownFormat => _error
    detail = I18n.t('errors.not_acceptable_response')
    [
      HTTP_STATUS, { 'Content-Type' => 'application/vnd.api+json' },
      [{ errors: [{ status: HTTP_STATUS, detail: detail }] }.to_json]
    ]
  end
end
