# frozen_string_literal: true

module SetInterestFiltersService
  def self.call(filter:, interest_ids_param:)
    return InterestFilter.none if interest_ids_param.blank?

    filter_interests_params = normalize_interest_ids(interest_ids_param)
    filter.filter_interests = filter_interests_params.map do |attrs|
      InterestFilter.find_or_initialize_by(filter: filter, interest_id: attrs[:id]).
        tap do |interest_filter|
        interest_filter.level = attrs[:level] if attrs[:level].present?

        if attrs[:level_by_admin].present?
          interest_filter.level_by_admin = attrs[:level_by_admin]
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
