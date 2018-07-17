# frozen_string_literal: true

module Metrojobb
  class JobWrapper
    attr_reader :job, :company

    def initialize(job:, staffing_company: nil)
      @job = job
      @company = staffing_company || @job.staffing_company || @job.company
    end

    delegate :city, to: :job
    delegate :full_time, to: :job

    def order_number
      job.id
    end

    def heading
      job.name
    end

    def job_title
      category
    end

    # NOTE: This is the "company description" its only called #summary because of
    # metrojobb legacy code..
    def summary
      company.description
    end

    def description
      StringFormatter.new.to_html(job.full_standalone_description)
    end

    def opportunities
      job.number_to_fill
    end

    def employer
      company.display_name
    end

    def employer_home_page
      company.website
    end

    def from_date
      DateFormatter.new.yyyy_mm_dd(job.publish_at)
    end

    def to_date
      DateFormatter.new.yyyy_mm_dd(job.last_application_at || job.job_end_date)
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
