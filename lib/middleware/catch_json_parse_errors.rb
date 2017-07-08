# frozen_string_literal: true

class CatchJsonParseErrors
  HTTP_STATUS = 400

  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue ActionDispatch::Http::Parameters::ParseError => error
    raise error unless json_content_type?(env)

    detail = I18n.t('errors.bad_json_format', error_class: error.class)
    [
      HTTP_STATUS, { 'Content-Type' => 'application/vnd.api+json' },
      [{ errors: [{ status: HTTP_STATUS, detail: detail }] }.to_json]
    ]
  end

  def json_content_type?(env)
    env['CONTENT_TYPE'] =~ %r{application\/json} ||
      env['CONTENT_TYPE'] =~ %r{application\/vnd.api+json}
  end
end
