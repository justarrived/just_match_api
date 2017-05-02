module Sweepers
  class FrilansFinansApiLogSweeper
    def self.destroy_old(scope: FrilansFinansApiLog, datetime: 1.week.ago)
      scope.before(:created_at, datetime).delete_all
    end
  end
end
