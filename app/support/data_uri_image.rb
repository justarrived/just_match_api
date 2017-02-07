# frozen_string_literal: true
class DataUriImage
  attr_reader :content_type

  def initialize(data_uri)
    @valid_data_uri = true
    @image = Paperclip.io_adapters.for(data_uri)
    @content_type = @image.content_type
  rescue Paperclip::AdapterRegistry::NoHandlerError => _e
    @valid_data_uri = false
  end

  def image
    return unless valid?

    content_type = @image.content_type
    @image.original_filename = ImageContentTypeHelper.original_filename(content_type)

    @image
  end

  def valid?
    valid_data_uri? && valid_content_type?
  end

  def valid_data_uri?
    @valid_data_uri
  end

  def valid_content_type?
    ImageContentTypeHelper.valid?(@content_type)
  end
end
