# frozen_string_literal: true
module Index
  class UsersIndex < BaseIndex
    def users
      @users ||= begin
        records = User.
                    includes(%i(skills jobs language languages owned_jobs))
        prepare_records(records)
      end
    end
  end
end
