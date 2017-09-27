# frozen_string_literal: true

class MetrojobbJobsSerializer
  def self.to_xml(jobs: [], locale: :sv)
    I18n.with_locale(locale) { build_xml_document(jobs) }
  end

  def self.build_xml_document(jobs)
    Metrojobb::Ads.new(jobs.map do |job|
      build_ad(Metrojobb::JobWrapper.new(job: job))
    end).to_xml
  end

  def self.build_ad(job)
    Metrojobb::Ad.new(
      order_number: job.order_number,
      external_application: job.external_application,
      heading: job.heading,
      job_title: job.job_title,
      summary: job.summary,
      description: job.description,
      employer: job.employer,
      employer_home_page: job.employer_home_page,
      from_date: job.from_date,
      to_date: job.to_date,
      external_logo_url: job.external_logo_url,
      application_url: job.application_url,
      opportunities: job.opportunities,
      # relations
      location: Metrojobb::Location.new(city: job.city),
      employment_type: Metrojobb::EmploymentType.new(id: employment_type(job)),
      category: Metrojobb::Category.new(id: job.category),
      region: Metrojobb::Region.new(id: job.region)
    )
  end

  def self.employment_type(job)
    name = if job.full_time
             'Heltid'
           else
             'Deltid'
           end
    type = Metrojobb::EmploymentType.new(name: name)
    type.employment_type_id
  end
end
