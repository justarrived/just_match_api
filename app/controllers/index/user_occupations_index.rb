# frozen_string_literal: true

module Index
  class UserOccupationsIndex < BaseIndex
    def user_occupations(scope = UserOccupation)
      @user_occupations ||= prepare_records(scope.includes(:occupation))
    end
  end
end
