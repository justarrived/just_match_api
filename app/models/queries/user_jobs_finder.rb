module Queries
  class UserJobsFinder
    def initialize(user)
      @user = user
    end

    def perform
      (@user.jobs + @user.owned_jobs).uniq
    end
  end
end
