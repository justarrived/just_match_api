# frozen_string_literal: true
require 'rack/test'

module TestImageFileReader
  def self.image
    test_file_name = "#{Rails.root}/spec/spec_support/data/1x1.jpg"
    Rack::Test::UploadedFile.new(test_file_name, 'image/png')
  end
end
