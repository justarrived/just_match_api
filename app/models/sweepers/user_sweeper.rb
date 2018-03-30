# frozen_string_literal: true

module Sweepers
  class UserSweeper
    def self.create_frilans_finans(scope = User)
      scope.needs_frilans_finans_id.find_each(batch_size: 500) do |user|
        SyncFrilansFinansUserService.call(user: user)
      end
    end
  end
end
