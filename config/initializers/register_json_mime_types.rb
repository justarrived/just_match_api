# frozen_string_literal: true
api_mime_types = %w(
  application/vnd.api+json
  text/x-json
  application/json
)
Mime::Type.register 'application/vnd.api+json', :json, api_mime_types
