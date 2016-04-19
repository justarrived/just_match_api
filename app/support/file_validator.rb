# frozen_string_literal: true
class FileValidator < Apipie::Validator::BaseValidator
  def name
    'File (multipart)'
  end

  def validate(value)
    value.is_a?(Rack::Test::UploadedFile) ||
      value.is_a?(ActionDispatch::Http::UploadedFile)
  end

  def self.build(param_description, argument, _options, _block)
    new(param_description) if argument == File
  end

  def description
    'Must be a valid file'
  end
end
