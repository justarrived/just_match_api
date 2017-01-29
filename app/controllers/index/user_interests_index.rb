# frozen_string_literal: true
module Index
  class UserInterestsIndex < BaseIndex
    def user_interests(scope = UserInterest)
      @user_interests ||= begin
        if included_resource?(:interest)
          scope = scope.includes(interest: [:language, :translations])
        end

        prepare_records(scope.includes(:interest, :user))
      end
    end
  end
end
