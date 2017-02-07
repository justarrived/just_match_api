# frozen_string_literal: true
class DataUriDocument
  attr_reader :content_type

  def initialize(data_uri)
    @valid_data_uri = true
    @document = Paperclip.io_adapters.for(data_uri)
    @content_type = @document.content_type
  rescue Paperclip::AdapterRegistry::NoHandlerError => _e
    @valid_data_uri = false
  end

  def document
    return unless valid?

    content_type = @document.content_type
    @document.original_filename = DocumentContentTypeHelper.original_filename(content_type) # rubocop:disable Metrics/LineLength

    @document
  end

  def valid?
    valid_data_uri? && valid_content_type?
  end

  def valid_data_uri?
    @valid_data_uri
  end

  def valid_content_type?
    DocumentContentTypeHelper.valid?(@content_type)
  end
end
