# frozen_string_literal: true
require 'rack/test'

module TestImageFileReader
  def self.image
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAIAAAACDbGyAAAAEElEQVR4AWMQ7d2BjCjlAwA4QCHL+OA2ggAAAABJRU5ErkJggg==' # rubocop:disable Metrics/LineLength
  end
end
