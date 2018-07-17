# frozen_string_literal: true

module Arbetsformedlingen
  class JobWrapper
    attr_reader :packet

    def initialize(arbetsformedlingen_ad, staffing_company: nil)
      @arbetsformedlingen_ad = arbetsformedlingen_ad
      @job = arbetsformedlingen_ad.job
      @employer = staffing_company || @job.staffing_company || @job.company
      @af_models = {}

      @packet = build_packet
    end

    def valid?
      errors.empty?
    end

    def errors
      @errors ||= begin
        @af_models.map do |name, model|
          [name, model.errors] if model.errors.any?
        end.compact.to_h
      end
    end

    private

    attr_reader :job, :arbetsformedlingen_ad, :employer

    def build_packet
      @af_models[:packet] ||= Arbetsformedlingen::Packet.new(
        publication: build_publication,
        document: build_document,
        position: build_position,
        attributes: {
          id: job.id,
          active: arbetsformedlingen_ad.published,
          job_id: job.to_param,
          number_to_fill: job.number_to_fill,
          occupation: arbetsformedlingen_ad.occupation
        }
      )
    end

    def build_position
      @af_models[:position] ||= begin
        salary = build_salary(
          salary_type: job.salary_type,
          currency: job.currency,
          summary: job.salary_summary
        )

        schedule = build_schedule(
          full_time: job.full_time,
          start_date: job.job_date,
          end_date: job.job_end_date,
          summary: job.schedule_summary
        )

        Arbetsformedlingen::Position.new(
          company: build_company,
          schedule: schedule,
          salary: salary,
          qualifications: build_qualifications,
          application_method: build_application_method,
          attributes: {
            title: job.name,
            purpose: StringFormatter.new.to_html(job.full_standalone_description),
            address: {
              country_code: job.country_code,
              zip: job.zip,
              municipality: job.municipality,
              street: job.street,
              city: job.city
            }
          }
        )
      end
    end

    def build_company
      @af_models[:company] ||= Arbetsformedlingen::Company.new(
        name: employer.display_name,
        cin: employer.formatted_cin,
        address: {
          country_code: employer.country_code,
          zip: employer.zip,
          municipality: employer.municipality,
          street: employer.street,
          city: employer.city
        }
      )
    end

    def build_qualifications
      @qualifications ||= begin
        [
          Arbetsformedlingen::Qualification.new(
            required: true,
            experience: false,
            drivers_license: job.swedish_drivers_license,
            car: job.car_required
          )
        ]
      end
    end

    def build_application_method
      @af_models[:application_method] ||= begin
        application_url = FrontendRouter.draw(
          :job,
          id: job.to_param,
          utm_source: 'arbetsformedlingen',
          utm_medium: 'ad',
          utm_content: job.to_param
        )

        Arbetsformedlingen::ApplicationMethod.new(
          external: true, # applications are not made through AF
          url: application_url,
          summary: I18n.t(
            'arbetsformedlingen.application_method_description',
            application_url: application_url
          )
        )
      end
    end

    def build_salary(salary_type:, currency:, summary:)
      @af_models[:salary] ||= Arbetsformedlingen::Salary.new(
        currency: currency,
        type: salary_type,
        summary: summary
      )
    end

    def build_schedule(full_time:, start_date:, end_date:, summary:)
      @af_models[:schedule] ||= Arbetsformedlingen::Schedule.new(
        summary: summary,
        full_time: full_time,
        start_date: start_date.to_date,
        end_date: end_date&.to_date
      )
    end

    def build_document
      @af_models[:document] ||= Arbetsformedlingen::Document.new(
        customer_id: AppSecrets.arbetsformedlingen_customer_id,
        email: AppSecrets.arbetsformedlingen_admin_email
      )
    end

    def build_publication
      @af_models[:publication] ||= Arbetsformedlingen::Publication.new(
        unpublish_at: job.last_application_at || job.job_end_date || job.job_date,
        name: AppConfig.arbetsformedlingen_default_publisher_name,
        email: AppConfig.arbetsformedlingen_default_publisher_email
      )
    end
  end
end
