# frozen_string_literal: true

module SetUserOccupationsService
  def self.call(user:, occupation_ids_param:)
    return UserOccupation.none if occupation_ids_param.nil?

    current_user_occupations = user.user_occupations
    user_occupations_params = normalize_occupation_ids(occupation_ids_param)
    user_occupations = user_occupations_params.map do |attrs|
      UserOccupation.find_or_initialize_by(
        user: user,
        occupation_id: attrs[:id]
      ).tap do |user_occupation|
        if attrs[:years_of_experience].present?
          user_occupation.years_of_experience = attrs[:years_of_experience]
        end
      end
    end
    user_occupations.each(&:save)

    # We want to replace all the occupations that the user just sent
    (current_user_occupations - user_occupations).each(&:destroy)

    user_occupations
  end

  def self.normalize_occupation_ids(occupation_ids_param)
    occupation_ids_param.map do |occupation|
      if occupation.respond_to?(:permit)
        occupation.permit(:id, :years_of_experience)
      else
        occupation
      end
    end
  end
end
