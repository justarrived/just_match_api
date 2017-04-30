# frozen_string_literal: true
class LinkedinJobsSerializer
  def self.attributes(jobs:)
    I18n.with_locale(:en) do
      jobs.map do |job|
        company = job.company
        attributes = {
          company: {
            name: company.name,
            id: company.cin,
            country_code: 'SE',
            postal_code: company.zip
          },
          job: {
            title: job.name,
            description: job.description,
            location: job.full_street_address,
            country_code: 'SE',
            postal_code: job.zip,
            application_url: FrontendRouter.draw(:job, id: job.id),
          }
        }
      end
    end
  end
end
