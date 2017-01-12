# frozen_string_literal: true
class ImageContentTypeHelper
  ALLOWED_IMAGE_CONTENT_TYPES = %w(image/jpeg image/png).freeze
  ALLOWED_FILE_EXTENSIONS = %w(jpeg png).freeze

  def self.valid?(content_type)
    content_type_allowed = ALLOWED_IMAGE_CONTENT_TYPES.include?(content_type)

    type = _file_type(content_type)
    extension_allowed = ALLOWED_FILE_EXTENSIONS.include?(type)

    content_type_allowed && extension_allowed
  end

  def self.original_filename(content_type)
    return unless valid?(content_type)

    SecureGenerator.token(length: 64) + file_extension(content_type)
  end

  def self.file_extension(content_type)
    return unless valid?(content_type)

    '.' + _file_type(content_type)
  end

  def self._file_type(content_type)
    content_type.split('/').last
  end
end
