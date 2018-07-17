# frozen_string_literal: true

class RemoveUserImagesService
  def self.call(user)
    user.user_images.each(&:destroy!)
  end
end
