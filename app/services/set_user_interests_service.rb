# frozen_string_literal: true
module SetUserInterestsService
  def self.call(user:, interest_ids_param:)
    return UserInterest.none if interest_ids_param.nil? || interest_ids_param.empty?

    user_interests_params = normalize_interest_ids(interest_ids_param)
    user.user_interests = user_interests_params.map do |attrs|
      UserInterest.find_or_initialize_by(user: user, interest_id: attrs[:id]).tap do |us|
        us.level = attrs[:level]

        unless attrs[:level_by_admin].blank?
          us.level_by_admin = attrs[:level_by_admin]
        end
      end
    end
  end

  def self.normalize_interest_ids(interest_ids_param)
    interest_ids_param.map do |interest|
      if interest.respond_to?(:permit)
        interest.permit(:id, :level)
      else
        interest
      end
    end
  end
end
