# frozen_string_literal: true
module Sweepers
  class UserImageSweeper
    def self.destroy_orphans(scope = UserImage)
      scope.over_aged_orphans.find_each(batch_size: 1000) do |user_image|
        user_image.destroy
      end
    end
  end
end
