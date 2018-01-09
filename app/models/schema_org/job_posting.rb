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
        # "baseSalary" => "100000", # NOTE => Only employers should provide baseSalary. If you're a third party job site, you can provide a salary estimate using the Occupation type.
        # "salaryCurrency" => "USD",
        # "baseSalary" => {
        #   "@type" => "MonetaryAmount",
        #   "currency" => "SEK",
        #   "value" => {
        #     "@type" => "QuantitativeValue",
        #     "value" => job.gross_amount,
        #     "unitText" => "HOUR"
        #   }
        # },
        'identifier' => {
          '@type' => 'PropertyValue',
          'name' => company.name,
          'value' => job.id
        },
        # "jobBenefits" => "Medical, Life, Dental",
        "datePosted" => DateFormatter.new.yyyy_mm_dd(job.publish_at), # alt. "2017-01-24T19:33:17+00:00"
        "description" => job.description,
        # "educationRequirements" => "Bachelor's Degree in Computer Science, Information Systems or related fields of study.",
        # "experienceRequirements" => "Minumum 3 years experience as a software engineer",
        # "incentiveCompensation" => "Performance-based annual bonus plan, project-completion bonuses",
        # "industry" => industry,
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
            # "addressRegion" => "MI",
            'postalCode' => job.zip,
            'addressCountry' => job.country_code
          }
        },
        # "occupationalCategory" => "15-1132.00 Software Developers, Application",
        'qualifications' => job.requirements_description,
        'responsibilities' => job.tasks_description,
        'skills' => job.applicant_description,
        # "specialCommitments" => "VeteranCommit",
        "title" => main_occupation.name,
        # "workHours" => "40 hours per week",
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
