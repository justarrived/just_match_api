# frozen_string_literal: true

module Linkedin
  class JobWrapper
    attr_reader :job, :company

    def initialize(job:, staffing_company: nil)
      @job = job
      @company = staffing_company || job.staffing_company || job.company
    end

    delegate :name, to: :company, prefix: true

    def partner_job_id
      job.to_param
    end

    def title
      job.name.to_s
    end

    def description
      "#{job.full_standalone_description}\n\n#welcometalent"
    end

    def location
      job.full_street_address
    end

    def country_code
      job.country_code.to_s
    end

    def city
      job.city.to_s
    end

    def postal_code
      job.zip.to_s
    end

    def apply_url
      job_param = job.to_param
      FrontendRouter.draw(
        :job,
        id: job_param,
        utm_source: 'linkedin',
        utm_medium: 'ad',
        utm_campaign: 'welcometalent',
        utm_content: job_param
      )
    end
  end
end
