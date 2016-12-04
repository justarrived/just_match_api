# frozen_string_literal: true
module Sweepers
  class UserSweeper
    def self.create_frilans_finans(scope = User)
      scope.needs_frilans_finans_id.find_each(batch_size: 1000) do |user|
        attributes = FrilansFinans::UserWrapper.attributes(user)
        ff_user = FrilansFinansApi::User.create(attributes: attributes)
        ff_id = ff_user.resource.id

        next if ff_id.nil?

        user.frilans_finans_id = ff_id.to_i
        user.save!
      end
    end
  end
end
