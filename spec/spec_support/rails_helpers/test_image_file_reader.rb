# frozen_string_literal: true
require 'rack/test'

module TestImageFileReader
  def self.image
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAIAAAACDbGyAAAAEElEQVR4AWMQ7d2BjCjlAwA4QCHL+OA2ggAAAABJRU5ErkJggg==' # rubocop:disable Metrics/LineLength
  end

  def self.image_file
    test_file_name = Rails.root.join('spec', 'spec_support', 'data', '1x1.jpg').to_s
    Rack::Test::UploadedFile.new(test_file_name, 'image/png')
  end
end
