# frozen_string_literal: true

module SetJobOccupationsService
  def self.call(job:, occupation_ids_param:)
    return JobOccupation.none if occupation_ids_param.nil?

    job_occupations_params = normalize_occupation_ids(occupation_ids_param)
    job_occupations = job_occupations_params.map do |attrs|
      JobOccupation.find_or_initialize_by(
        job: job,
        occupation_id: attrs[:id]
      ).tap do |job_occupation|
        if attrs[:importance].present?
          job_occupation.importance = attrs[:importance]
        end

        if attrs[:years_of_experience].present?
          job_occupation.years_of_experience = attrs[:years_of_experience]
        end
      end
    end
    job_occupations.each(&:save)
    job_occupations
  end

  def self.normalize_occupation_ids(occupation_ids_param)
    occupation_ids_param.map do |occupation|
      if occupation.respond_to?(:permit)
        occupation.permit(:id, :proficiency)
      else
        occupation
      end
    end
  end
end
