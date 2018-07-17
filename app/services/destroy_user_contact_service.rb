# frozen_string_literal: true

# Removes all possiblities for the system to accidentally contact a user
class DestroyUserContactService
  def self.call(user)
    user.email = EmailAddress.random
    user.phone = nil
    user.digest_subscriber(&:mark_destroyed)&.save!
    user.save!
  end
end
