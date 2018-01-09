# frozen_string_literal: true

module SchemaOrg
  # @see http://schema.org/JobPosting
  # @see https://developers.google.com/search/docs/data-types/job-posting#definitions
  class JobPosting
    attr_reader :job, :company, :main_occupation

    def initialize(job:, company:, main_occupation:)
      @job = job
      @company = company
      @main_occupation = main_occupation
    end

    # @see http://schema.org/JobPosting
    # @see https://developers.google.com/search/docs/data-types/job-posting#definitions
    def to_h
      data = {
        '@context' => 'http://schema.org',
        '@type' => 'JobPosting',
        'identifier' => {
          '@type' => 'PropertyValue',
          'name' => company.name,
          'value' => job.id
        },
        'datePosted' => DateFormatter.new.yyyy_mm_dd(job.publish_at),
        'description' => job.description,
        'employmentType' => employment_type,
        'hiringOrganization' => {
          '@type' => 'Organization',
          'name' => company.name,
          'sameAs' => company.website,
          'logo' => company_logo
        },
        'jobLocation' => {
          '@type' => 'Place',
          'address' => {
            '@type' => 'PostalAddress',
            'streetAddress' => job.street,
            'addressLocality' => job.city,
            'postalCode' => job.zip,
            'addressCountry' => job.country_code
          }
        },
        'qualifications' => job.requirements_description,
        'responsibilities' => job.tasks_description,
        'skills' => job.applicant_description,
        'title' => main_occupation.name
      }
      if job.last_application_at
        # "2017-02-24" or "2017-02-24T19:33:17+00:00"
        # NOTE: This is required for job postings that have an expiration date.
        #  If a job posting never expires, or you do not know when the job will expire,
        #  do not include this property.
        data['validThrough'] = DateFormatter.new.yyyy_mm_dd(job.last_application_at)
      end

      data
    end

    private

    def employment_type
      # Must be an array of
      #   - "FULL_TIME"
      #   - "PART_TIME"
      #   - "CONTRACTOR"
      #   - "TEMPORARY"
      #   - "INTERN"
      #   - "VOLUNTEER"
      #   - "PER_DIEM"
      #   - "OTHER"
      return %w[FULL_TIME] if job.full_time

      %w[PART_TIME]
    end

    def company_logo
      company.company_image_logo&.image&.url(:medium)
    end
  end
end
