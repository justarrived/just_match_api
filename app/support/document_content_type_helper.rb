# frozen_string_literal: true

class DocumentContentTypeHelper
  CONTENT_TYPES_MAP = {
    'application/pdf' => 'pdf',
    'application/msword' => 'doc',
    'application/zip' => 'docx',
    'application/x-ole-storage' => 'doc',
    'application/vnd.oasis.opendocument.text' => 'odt',
    'text/plain' => 'txt',
    'application/rtf' => 'rtf',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document' => 'docx'
  }.freeze
  ALLOWED_DOCUMENT_CONTENT_TYPES = CONTENT_TYPES_MAP.keys.dup.freeze
  ALLOWED_FILE_EXTENSIONS = CONTENT_TYPES_MAP.values.dup.freeze

  def self.valid?(content_type)
    content_type_allowed = ALLOWED_DOCUMENT_CONTENT_TYPES.include?(content_type)

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
    CONTENT_TYPES_MAP.fetch(content_type, nil)
  end
end
