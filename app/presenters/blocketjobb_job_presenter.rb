# frozen_string_literal: true

class BlocketjobbJobPresenter
  attr_reader :job, :company

  def initialize(job)
    @job = job
    @company = job.company
  end

  def external_ad_id
    job.to_param
  end

  def display_at
    'jobb' # List only on Blocketjobb
  end

  def subject
    job.name
  end

  def body
    job.description
  end

  def apply_date
    # Mandatory, Ad end date, YYYY-MM-DD
    # (MAX 60 days into the future, MIN 2 days from NOW)
    last_application_at = job.last_application_at
    min_last_application_date = 2.days.from_now
    max_last_application_date = 60.days.from_now

    apply_before = if last_application_at > max_last_application_date
                     max_last_application_date
                   elsif last_application_at < min_last_application_date
                     min_last_application_date
                   else
                     last_application_at
                   end

    to_yyyy_mm_dd(apply_before)
  end

  def employment
    # 1 => Heltid
    # 2 => Deltid
    # 3 => Extrajobb
    # 4 => Sasongsjobb
    # 5 => Franchise
    # 6 => Tillsvidareanstalld
    # 7 => Projekt- / Visstidsanstalld
    # 8 => Trainee
    # 9 => Internship / Praktik
    # 10 => Examensarbete
    # 11 => Vikariat
    # 12 => Frilans
    return '1' if job.full_time

    '2'
  end

  def job_ad_type
    # 1 => Direkt
    # 2 => Rekrytering
    # 3 => Bemanning
    # 4 => Statlig
    return '2' if job.direct_recruitment_job

    '3'
  end

  def address
    company.full_street_address
  end

  def zipcode
    company.zip
  end

  delegate :name, to: :company, prefix: true
  delegate :description, to: :company, prefix: true

  def company_orgno
    company.cin
  end

  def company_url
    company.website.to_s
  end

  def provider_name
    'JustMatch'
  end

  def apply_url
    FrontendRouter.draw(
      :job,
      id: job.to_param,
      utm_source: 'blocketjobb',
      utm_medium: 'ad'
    )
  end

  def publication_date
    to_yyyy_mm_dd(job.created_at)
  end

  def update_date
    to_yyyy_mm_dd(job.updated_at)
  end

  def end_date
    apply_date
  end

  def company_logo_url
    return '' unless company
    logo = company.company_image_logo
    return '' unless logo

    logo.image.url(:large).to_s
  end

  def header_logo
    fail(NotImplementedError)
  end

  def category
    BlocketjobbCategories.to_code!(job.blocketjobb_category)
  end

  def region
    BlocketRegionCodes.to_region_code(job.municipality)
  end

  def region_name
    BlocketRegionCodes.to_region_name(job.municipality)
  end

  def municipality
    BlocketRegionCodes.to_municipality_code(job.municipality)
  end

  private

  def to_yyyy_mm_dd(date)
    date.strftime('%Y-%m-%d')
  end
end
