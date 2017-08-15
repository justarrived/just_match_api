# frozen_string_literal: true

module SetJobIndustriesService
  def self.call(job:, industry_ids_param:)
    return JobIndustry.none if industry_ids_param.nil?

    job_industries_params = normalize_industry_ids(industry_ids_param)
    job_industries = job_industries_params.map do |attrs|
      JobIndustry.find_or_initialize_by(
        job: job,
        industry_id: attrs[:id]
      ).tap do |job_industry|
        if attrs[:importance].present?
          job_industry.importance = attrs[:importance]
        end

        if attrs[:years_of_experience].present?
          job_industry.years_of_experience = attrs[:years_of_experience]
        end
      end
    end
    job_industries.each(&:save)
    job_industries
  end

  def self.normalize_industry_ids(industry_ids_param)
    industry_ids_param.map do |industry|
      if industry.respond_to?(:permit)
        industry.permit(:id, :proficiency)
      else
        industry
      end
    end
  end
end
