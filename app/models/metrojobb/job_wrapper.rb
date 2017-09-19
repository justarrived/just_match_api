# frozen_string_literal: true

module Metrojobb
  class JobWrapper
    attr_reader :job

    def initialize(job:)
      @job = job
    end

    delegate :description, to: :job
    delegate :city, to: :job
    delegate :full_time, to: :job

    def order_number
      job.id
    end

    def heading
      job.name
    end

    def job_title
      job.category.name
    end

    def summary
      job.short_description
    end

    def employer
      job.company.name
    end

    def employer_home_page
      job.company.website
    end

    def from_date
      DateFormatter.new.yyyy_mm_dd(job.publish_at)
    end

    def to_date
      DateFormatter.new.yyyy_mm_dd(job.last_application_at || job.job_date)
    end

    def external_logo_url
      AppConfig.metrojobb_customer_logo_url
    end

    def category
      job.metrojobb_category
    end

    def region
      code = Arbetsformedlingen::MunicipalityCode.to_code(job.municipality).to_s
      # blocketjobb does not want a leading 0 as Arbetsformedlingen does
      return code[1..-1] if code.start_with?('0')
      code
    end

    def application_url
      job_param = job.to_param
      FrontendRouter.draw(
        :job,
        id: job_param,
        utm_source: 'metrojobb',
        utm_medium: 'ad',
        utm_content: job_param
      )
    end

    def external_application
      true
    end
  end
end
