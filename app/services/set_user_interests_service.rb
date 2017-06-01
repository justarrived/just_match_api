# frozen_string_literal: true

module SetUserInterestsService
  def self.call(user:, interest_ids_param:)
    return UserInterest.none if interest_ids_param.nil?

    current_user_interests = user.user_interests
    user_interests_params = normalize_interest_ids(interest_ids_param)
    user_interests = user_interests_params.map do |attrs|
      UserInterest.find_or_initialize_by(user: user, interest_id: attrs[:id]).tap do |us|
        us.level = attrs[:level] if attrs[:level].present?
        us.level_by_admin = attrs[:level_by_admin] if attrs[:level_by_admin].present?
      end
    end
    user_interests.each(&:save)

    # We want to replace all the interests that the user just sent in, but we don't
    # want to delete the interests that an admin has touched
    (current_user_interests - user_interests).each do |user_interest|
      user_interest.destroy if user_interest.level_by_admin.nil?
    end

    user_interests
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
