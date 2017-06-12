# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job, type: :model do
  describe '::published' do
    it 'only returns published jobs' do
      # Not published
      FactoryGirl.create(:job, publish_at: nil, unpublish_at: nil)
      FactoryGirl.create(:job, publish_at: 2.days.ago, unpublish_at: 1.day.ago)
      FactoryGirl.create(:job, publish_at: 1.day.ago, unpublish_at: nil, hidden: true)
      # Published
      FactoryGirl.create(:job, publish_at: 1.day.ago, unpublish_at: nil)
      FactoryGirl.create(:job, publish_at: 2.days.ago, unpublish_at: 1.day.from_now)

      expect(Job.published.count).to eq(2)
    end
  end

  describe '#application_url' do
    it 'returns the correct application URL' do
      id = 7
      job = Job.new(id: id)
      expect(job.application_url).to eq(FrontendRouter.draw(:job, id: id))
    end
  end

  describe '#open_for_applications?' do
    it 'returns false if job is cancelled' do
      job = FactoryGirl.build(:job, cancelled: true)
      expect(job.open_for_applications?).to eq(false)
    end

    it 'returns false if job is filled' do
      job = FactoryGirl.build(:job, filled: true)
      expect(job.open_for_applications?).to eq(false)
    end

    it 'returns true if job is open for applications' do
      job = FactoryGirl.build(
        :job,
        last_application_at: 2.days.from_now,
        cancelled: false,
        filled: false
      )
      expect(job.open_for_applications?).to eq(true)
    end
  end

  describe '#full_standalone_description' do
    it 'contains headings for all present fields' do
      job = FactoryGirl.build(:job, applicant_description: 'Testing')
      result = job.full_standalone_description
      expect(result).to include(I18n.t('job.description_title'))
      expect(result).to include(I18n.t('job.applicant_description_title'))
      expect(result).not_to include(I18n.t('job.tasks_description_title'))
      expect(result).not_to include(I18n.t('job.requirements_description_title'))
    end
  end

  describe '#ended?' do
    it 'returns false if job end date is in the future' do
      job = FactoryGirl.build(:job, job_end_date: 1.minute.from_now)
      expect(job.ended?).to eq(false)
    end

    it 'returns true if job end date is in the passed' do
      job = FactoryGirl.build(:job, job_end_date: 1.minute.ago)
      expect(job.ended?).to eq(true)
    end
  end

  describe '#to_form_array' do
    context 'with include blank false' do
      it 'returns empty array if no skills' do
        job_array = described_class.to_form_array(include_blank: false)
        expect(job_array).to eq([])
      end

      it 'returns skill array' do
        job = FactoryGirl.create(:job_with_translation, name: 'Job name')
        job_array = described_class.to_form_array(include_blank: false)
        expect(job_array).to eq([["##{job.id} Job name", job.id]])
      end
    end

    context 'with include blank' do
      let(:label) { I18n.t('admin.form.no_job_chosen') }

      it 'returns empty array if no jobs' do
        job_array = described_class.to_form_array(include_blank: true)
        expect(job_array).to eq([[label, nil]])
      end

      it 'returns job array' do
        job = FactoryGirl.create(:job_with_translation, name: 'Job name')
        job_array = described_class.to_form_array(include_blank: true)
        expect(job_array).to eq([[label, nil], ["##{job.id} Job name", job.id]])
      end
    end
  end

  describe '#invoice_company_frilans_finans_id' do
    let(:company) { FactoryGirl.build(:company, frilans_finans_id: 7373) }
    let(:owner) { FactoryGirl.build(:user, company: company) }
    let(:job) { FactoryGirl.build(:job, owner: owner) }

    context 'with configuration default_invoice_company_frilans_finans_id' do
      it 'returns id from config' do
        ff_id = 3_737_337
        Rails.configuration.x.invoice_company_frilans_finans_id = ff_id
        expect(job.invoice_company_frilans_finans_id).to eq(ff_id)
        Rails.configuration.x.invoice_company_frilans_finans_id = nil
      end
    end

    context '*without* configuration default_invoice_company_frilans_finans_id' do
      it 'returns id from config' do
        expected_id = company.frilans_finans_id
        expect(job.invoice_company_frilans_finans_id).to eq(expected_id)
      end
    end
  end

  describe '#fill_position' do
    it 'sets filled to true' do
      job = FactoryGirl.build(:job, filled: false)
      job.fill_position
      expect(job.filled).to eq(true)
    end
  end

  describe '#fill_position!' do
    it 'sets filled to true' do
      job = FactoryGirl.build(:job, filled: false)
      job.fill_position!
      expect(job.filled).to eq(true)
    end
  end

  describe '#invoice_specification' do
    let(:job_id) { 73_000_000 }
    let(:job) { FactoryGirl.build(:job, job_end_date: 2.weeks.from_now, id: job_id) }

    it 'returns with the correct content parts' do
      [
        job.category.name,
        job.name,
        job.id,
        job.job_date.to_date,
        job.job_end_date.to_date,
        job.hours,
        job.hourly_pay.invoice_rate,
        job.hourly_pay.gross_salary,
        job.company.name,
        job.company.cin,
        job.company.billing_email,
        job.company.address
      ].map(&:to_s).each do |expected_part|
        expect(job.invoice_specification).to include(expected_part)
      end
    end
  end

  describe '#gross_amount' do
    it 'can return the total gross amount that a user is to be payed' do
      hourly_pay = FactoryGirl.build(:hourly_pay, gross_salary: 100)
      job = FactoryGirl.build(:job, hours: 2, hourly_pay: hourly_pay)
      expect(job.gross_amount).to eq(200)
    end
  end

  describe '#send_cancelled_notice?' do
    let(:job) { described_class.new }

    it 'returns true if notice should be sent' do
      job.cancelled = true
      result = job.send_cancelled_notice?
      expect(result).to eq(true)
    end

    it 'returns false if notice should be sent' do
      job.cancelled = false
      result = job.send_cancelled_notice?
      expect(result).to eq(false)
    end
  end

  describe 'geocodable' do
    let(:job) do
      FactoryGirl.create(:job, city: nil, street: 'Bankgatan 14C', zip: '223 52')
    end

    it 'geocodes by exact address' do
      expect(job.latitude).to eq(55.6997802)
      expect(job.longitude).to eq(13.1953695)
    end

    it 'geocodes by zip' do
      expect(job.zip_latitude).to eq(55.6987817)
      expect(job.zip_longitude).to eq(13.1975525)
    end

    it 'zip lat/long is different from lat/long' do
      expect(job.zip_latitude).not_to eq(job.latitude)
      expect(job.zip_longitude).not_to eq(job.longitude)
    end
  end

  describe '#owner?' do
    let(:user) { FactoryGirl.build(:company_user) }
    let(:job) { FactoryGirl.build(:job, owner: user) }

    it 'returns true if user is owner' do
      expect(job.owner?(user)).to eq(true)
    end

    it 'returns true if user is owner' do
      a_user = FactoryGirl.build(:user)
      expect(job.owner?(a_user)).to eq(false)
    end

    it 'returns false if owner is nil and user is not nil' do
      a_user = FactoryGirl.build(:user)
      expect(job.owner?(a_user)).to eq(false)
    end

    it 'returns false if owner is nil and user is nil' do
      expect(job.owner?(nil)).to eq(false)
    end
  end

  describe '#accepted_applicant' do
    it 'returns nil if no accepted applicant' do
      job = described_class.new
      expect(job.accepted_applicant).to eq(nil)
    end

    it 'returns accepted user if no job user' do
      applicant = FactoryGirl.create(:user)
      owner = FactoryGirl.create(:company_user)
      job = FactoryGirl.create(:job, owner: owner)

      job.create_applicant!(applicant)
      job.accept_applicant!(applicant)

      expect(job.accepted_applicant).to eq(applicant)
    end
  end

  describe '#accept_applicant?' do
    it 'returns false if user is *not* the accepted user' do
      job = described_class.new
      user = FactoryGirl.build(:user)
      expect(job.accepted_applicant?(user)).to eq(false)
    end

    it 'returns true if user is the accepted user' do
      applicant = FactoryGirl.create(:user)
      owner = FactoryGirl.create(:company_user)
      job = FactoryGirl.create(:job, owner: owner)

      job.create_applicant!(applicant)
      job.accept_applicant!(applicant)

      expect(job.accepted_applicant?(applicant)).to eq(true)
    end

    it 'returns false if owner is nil and user is not' do
      nil_job = Job.new
      a_user = FactoryGirl.build(:user)
      expect(nil_job.accepted_applicant?(a_user)).to eq(false)
    end

    it 'returns false if owner is nil and user is nil' do
      nil_job = Job.new
      expect(nil_job.accepted_applicant?(nil)).to eq(false)
    end
  end

  describe '#workdays' do
    context 'less than a week' do
      it 'returns all days' do
        start_date = Date.new(2016, 4, 22)
        end_date = Date.new(2016, 4, 26)
        job_attributes = { job_date: start_date, job_end_date: end_date }
        job = FactoryGirl.build(:job, job_attributes)
        expected = [
          Date.new(2016, 4, 22),
          Date.new(2016, 4, 23),
          Date.new(2016, 4, 24),
          Date.new(2016, 4, 25),
          Date.new(2016, 4, 26)
        ]
        expect(job.workdays).to eq(expected)
      end
    end

    context 'more than a week' do
      it 'returns all weekdays' do
        start_date = Date.new(2016, 4, 22)
        end_date = Date.new(2016, 4, 30)
        job_attributes = { job_date: start_date, job_end_date: end_date }
        job = FactoryGirl.build(:job, job_attributes)
        expected = [
          Date.new(2016, 4, 22),
          Date.new(2016, 4, 25),
          Date.new(2016, 4, 26),
          Date.new(2016, 4, 27),
          Date.new(2016, 4, 28),
          Date.new(2016, 4, 29)
        ]
        expect(job.workdays).to eq(expected)
      end
    end

    it 'returns nil if job date is nil' do
      job = FactoryGirl.build(:job, job_date: nil)
      expect(job.workdays).to be_nil
    end

    it 'returns nil if job end date is nil' do
      job = FactoryGirl.build(:job, job_end_date: nil)
      expect(job.workdays).to be_nil
    end
  end

  describe '#locked_for_changes?' do
    let(:job) { FactoryGirl.create(:job) }

    it 'returns false when there is no accepted applicant' do
      expect(job.locked_for_changes?).to eq(false)
    end

    it 'returns false when there is an accepted applicant, but has *not* confirmed' do
      FactoryGirl.create(:job_user, job: job, accepted: true)
      expect(job.locked_for_changes?).to eq(false)
    end

    it 'returns true when there is an accepted applicant, that has confirmed' do
      FactoryGirl.create(:job_user, job: job, accepted: true, will_perform: true)
      expect(job.locked_for_changes?).to eq(true)
    end
  end

  describe '#started?' do
    it 'returns true for an inprogress job' do
      job = FactoryGirl.build(:inprogress_job)
      expect(job.started?).to eq(true)
    end

    it 'returns false for a future job' do
      job = FactoryGirl.build(:future_job)
      expect(job.started?).to eq(false)
    end

    it 'returns true for a passed job' do
      job = FactoryGirl.build(:passed_job)
      expect(job.started?).to eq(true)
    end
  end

  describe '#validate_job_date_in_future' do
    it 'adds error if the job_date is in the passed' do
      job = FactoryGirl.build(:job, job_date: 1.day.ago)
      job.validate
      message = I18n.t('errors.job.job_date_in_the_past')
      expect(job.errors.messages[:job_date]).to include(message)
    end

    it 'adds *no* error if the job_date is in the passed but has not changed' do
      new_name = 'Watwoman'
      job = FactoryGirl.build(:job, job_date: 1.day.ago)
      job.save(validate: false)
      job.name = new_name
      job.save
      message = I18n.t('errors.job.job_date_in_the_past')
      expect(job.errors.messages[:job_date] || []).not_to include(message)
      expect(job.name).to eq(new_name)
    end

    it 'adds *no* error if the job_date is nil' do
      job = FactoryGirl.build(:job, job_date: nil)
      job.validate
      message = I18n.t('errors.job.job_date_in_the_past')
      expect(job.errors.messages[:job_date]).not_to include(message)
    end

    it 'adds *no* error if the job_date is in the future' do
      job = FactoryGirl.build(:job, job_date: 1.week.from_now)
      job.validate
      message = I18n.t('errors.job.job_date_in_the_past')
      expect(job.errors.messages[:job_date] || []).not_to include(message)
    end
  end

  describe 'validates that municipality is a valid Swedish municipality' do
    it 'adds error if the municipality is not known' do
      job = FactoryGirl.build(:job, municipality: 'watman')
      job.validate
      message = I18n.t('errors.validators.swedish_municipality')
      expect(job.errors.messages[:municipality]).to include(message)
    end

    it 'adds *no* error if the municipality is known' do
      job = FactoryGirl.build(:job, municipality: 'Stockholm')
      job.validate
      message = I18n.t('errors.validators.swedish_municipality')
      expect(job.errors.messages[:municipality]).not_to include(message)
    end
  end

  describe '#validate_job_end_date_after_job_date' do
    it 'adds error if job end date is before job date' do
      attributes = { job_date: 2.days.from_now, job_end_date: 1.day.from_now }
      job = FactoryGirl.build(:job, attributes)
      job.validate
      message = I18n.t('errors.job.job_end_date_after_job_date')
      expect(job.errors.messages[:job_end_date]).to include(message)
    end

    it 'adds *no* error if the job_end_date is equal to job_date' do
      job = FactoryGirl.build(:job, job_date: Date.tomorrow, job_end_date: Date.tomorrow)
      job.validate
      message = I18n.t('errors.job.job_end_date_after_job_date')
      expect(job.errors.messages[:job_end_date] || []).not_to include(message)
    end

    it 'adds *no* error if the job_end_date is nil' do
      job = FactoryGirl.build(:job, job_end_date: nil)
      job.validate
      message = I18n.t('errors.job.job_end_date_after_job_date')
      expect(job.errors.messages[:job_end_date] || []).not_to include(message)
    end

    it 'adds *no* error if the job_date is in the future' do
      job = FactoryGirl.build(:job, job_end_date: 1.week.from_now)
      job.validate
      message = I18n.t('errors.job.job_end_date_after_job_date')
      expect(job.errors.messages[:job_end_date] || []).not_to include(message)
    end
  end

  describe '#validate_last_application_at_on_publish_to_blocketjobb' do
    it 'adds error if last_application_at is not set and publish_on_blocketjobb is true' do # rubocop:disable Metrics/LineLength
      job = FactoryGirl.build(
        :job,
        last_application_at: nil,
        publish_on_blocketjobb: true
      )
      job.validate
      message = I18n.t('errors.job.last_application_at_on_publish_to_blocketjobb')
      expect(job.errors.messages[:last_application_at]).to include(message)
    end

    it 'adds *no* error if #last_application_at is set' do
      job = FactoryGirl.build(
        :job,
        last_application_at: Date.tomorrow,
        publish_on_blocketjobb: true
      )
      job.validate
      message = I18n.t('errors.job.last_application_at_on_publish_to_blocketjobb')
      expect(job.errors.messages[:last_application_at]).not_to include(message)
    end
  end

  describe '#validate_municipality_presence_on_publish_to_blocketjobb' do
    it 'adds error if municipality is not set and publish_on_blocketjobb is true' do
      job = FactoryGirl.build(:job, municipality: nil, publish_on_blocketjobb: true)
      job.validate
      message = I18n.t('errors.job.municipality_presence_on_publish_to_blocketjobb')
      expect(job.errors.messages[:municipality]).to include(message)
    end

    it 'adds *no* error if #municipality is set' do
      job = FactoryGirl.build(
        :job,
        municipality: 'Stockholm',
        publish_on_blocketjobb: true
      )
      job.validate
      message = I18n.t('errors.job.municipality_presence_on_publish_to_blocketjobb')
      expect(job.errors.messages[:municipality]).not_to include(message)
    end
  end

  describe '#validate_blocketjobb_category_presence_on_publish_to_blocketjobb' do
    it 'adds error if blocketjobb_category is not set and publish_on_blocketjobb is true' do # rubocop:disable Metrics/LineLength
      job = FactoryGirl.build(
        :job,
        blocketjobb_category: nil,
        publish_on_blocketjobb: true
      )
      job.validate
      message = I18n.t('errors.job.blocketjobb_category_presence_on_publish_to_blocketjobb') # rubocop:disable Metrics/LineLength
      expect(job.errors.messages[:blocketjobb_category]).to include(message)
    end

    it 'adds *no* error if #blocketjobb_category is set' do
      job = FactoryGirl.build(
        :job,
        blocketjobb_category: 'Övrigt',
        publish_on_blocketjobb: true
      )
      job.validate
      message = I18n.t('errors.job.blocketjobb_category_presence_on_publish_to_blocketjobb') # rubocop:disable Metrics/LineLength
      expect(job.errors.messages[:blocketjobb_category]).not_to include(message)
    end
  end

  describe '#validate_company_presence_on_publish_to_blocketjobb' do
    it 'adds error if company is not set (through owner) and publish_on_blocketjobb is true' do # rubocop:disable Metrics/LineLength
      owner = FactoryGirl.build(:user)
      job = FactoryGirl.build(:job, owner: owner, publish_on_blocketjobb: true)
      job.validate
      message = I18n.t('errors.job.company_presence_on_publish_to_blocketjobb')
      expect(job.errors.messages[:company]).to include(message)
    end

    it 'adds *no* error if #company is set' do
      owner = FactoryGirl.create(:company_user)
      job = FactoryGirl.build(:job, owner: owner, publish_on_blocketjobb: true)
      job.validate
      message = I18n.t('errors.job.company_presence_on_publish_to_blocketjobb')
      expect(job.errors.messages[:company]).not_to include(message)
    end
  end

  describe '#validate_hourly_rate_active' do
    it 'adds error if the hourly pay is *not* active' do
      hourly_pay = FactoryGirl.build(:inactive_hourly_pay)
      job = FactoryGirl.build(:job, hourly_pay: hourly_pay)
      job.validate
      message = I18n.t('errors.job.hourly_pay_active')
      expect(job.errors.messages[:hourly_pay]).to include(message)
    end

    it 'adds error if the hourly pay is *not* active' do
      hourly_pay = FactoryGirl.build(:hourly_pay, active: true)
      job = FactoryGirl.build(:job, hourly_pay: hourly_pay)
      job.validate
      message = I18n.t('errors.job.hourly_pay_active')
      expect(job.errors.messages[:hourly_pay] || []).not_to include(message)
    end
  end

  describe '#validate_within_allowed_hours' do
    let(:min_hours_error_message) do
      I18n.t('errors.job.hours_lower_bound', min_hours: Job::MIN_HOURS_PER_DAY)
    end

    let(:max_hours_error_message) do
      I18n.t('errors.job.hours_upper_bound', max_hours: Job::MAX_HOURS_PER_DAY)
    end

    it 'adds *no* error if within allowed hours' do
      start_date = Date.new(2016, 4, 27)
      end_date = Date.new(2016, 4, 28)
      job_attributes = { job_date: start_date, job_end_date: end_date, hours: 3 }
      job = FactoryGirl.build(:job, job_attributes)

      job.validate
      expect(job.errors.messages[:hours] || []).not_to include(max_hours_error_message)
    end

    context 'more than one week' do
      it 'adds error if under allowed hours' do
        start_date = Date.new(2016, 4, 4)
        end_date = Date.new(2016, 4, 18)
        job_attributes = { job_date: start_date, job_end_date: end_date, hours: 3 }
        job = FactoryGirl.build(:job, job_attributes)

        job.validate
        expect(job.errors.messages[:hours]).to include(min_hours_error_message)
      end

      it 'adds error if over allowed hours' do
        start_date = Date.new(2016, 4, 4)
        end_date = Date.new(2016, 4, 18)
        job_attributes = { job_date: start_date, job_end_date: end_date, hours: 300 }
        job = FactoryGirl.build(:job, job_attributes)

        job.validate
        expect(job.errors.messages[:hours]).to include(max_hours_error_message)
      end
    end

    context 'less than one week' do
      it 'adds error if under allowed hours' do
        start_date = Date.new(2016, 4, 8)
        end_date = Date.new(2016, 4, 10)
        job_attributes = { job_date: start_date, job_end_date: end_date, hours: 1 }
        job = FactoryGirl.build(:job, job_attributes)

        job.validate
        expect(job.errors.messages[:hours]).to include(min_hours_error_message)
      end

      it 'adds error if over allowed hours' do
        start_date = Date.new(2016, 4, 8)
        end_date = Date.new(2016, 4, 10)
        job_attributes = { job_date: start_date, job_end_date: end_date, hours: 100 }
        job = FactoryGirl.build(:job, job_attributes)

        job.validate
        expect(job.errors.messages[:hours]).to include(max_hours_error_message)
      end
    end
  end

  describe '#validate_owner_belongs_to_company' do
    it 'adds error if owner does *not* belong to a company' do
      owner = FactoryGirl.build(:user, company: nil)
      job = FactoryGirl.build(:job, owner: owner)
      job.validate
      message = I18n.t('errors.job.owner_must_belong_to_company')
      expect(job.errors.messages[:owner]).to include(message)
    end

    it 'adds no error if the owner belongs to a company' do
      owner = FactoryGirl.build(:company_user)
      job = FactoryGirl.build(:job, owner: owner)
      job.validate
      message = I18n.t('errors.job.owner_must_belong_to_company')
      expect(job.errors.messages[:owner] || []).not_to include(message)
    end
  end

  describe '#salary_summary' do
    it 'returns salary summary that includes the gross hourly pay' do
      I18n.with_locale(:sv) do
        expect(FactoryGirl.build(:job).salary_summary).to include('100 SEK/timmen')
      end
    end
  end

  describe '#schedule_summary' do
    it 'returns schedule summary that includes the job start date' do
      I18n.with_locale(:sv) do
        job = FactoryGirl.build(:job)
        expect(job.schedule_summary).to include(job.job_date.to_date.to_s)
      end
    end
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id                           :integer          not null, primary key
#  description                  :text
#  job_date                     :datetime
#  hours                        :float
#  name                         :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  owner_user_id                :integer
#  latitude                     :float
#  longitude                    :float
#  language_id                  :integer
#  street                       :string
#  zip                          :string
#  zip_latitude                 :float
#  zip_longitude                :float
#  hidden                       :boolean          default(FALSE)
#  category_id                  :integer
#  hourly_pay_id                :integer
#  verified                     :boolean          default(FALSE)
#  job_end_date                 :datetime
#  cancelled                    :boolean          default(FALSE)
#  filled                       :boolean          default(FALSE)
#  short_description            :string
#  featured                     :boolean          default(FALSE)
#  upcoming                     :boolean          default(FALSE)
#  company_contact_user_id      :integer
#  just_arrived_contact_user_id :integer
#  city                         :string
#  staffing_job                 :boolean          default(FALSE)
#  direct_recruitment_job       :boolean          default(FALSE)
#  order_id                     :integer
#  municipality                 :string
#  number_to_fill               :integer          default(1)
#  full_time                    :boolean          default(FALSE)
#  swedish_drivers_license      :string
#  car_required                 :boolean          default(FALSE)
#  salary_type                  :integer          default("fixed")
#  publish_on_linkedin          :boolean          default(FALSE)
#  publish_on_blocketjobb       :boolean          default(FALSE)
#  last_application_at          :datetime
#  blocketjobb_category         :string
#  publish_at                   :datetime
#  unpublish_at                 :datetime
#  tasks_description            :text
#  applicant_description        :text
#  requirements_description     :text
#
# Indexes
#
#  index_jobs_on_category_id    (category_id)
#  index_jobs_on_hourly_pay_id  (hourly_pay_id)
#  index_jobs_on_language_id    (language_id)
#  index_jobs_on_order_id       (order_id)
#
# Foreign Keys
#
#  fk_rails_...                          (category_id => categories.id)
#  fk_rails_...                          (hourly_pay_id => hourly_pays.id)
#  fk_rails_...                          (language_id => languages.id)
#  fk_rails_...                          (order_id => orders.id)
#  jobs_company_contact_user_id_fk       (company_contact_user_id => users.id)
#  jobs_just_arrived_contact_user_id_fk  (just_arrived_contact_user_id => users.id)
#  jobs_owner_user_id_fk                 (owner_user_id => users.id)
#
