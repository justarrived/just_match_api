# frozen_string_literal: true

FactoryGirl.define do
  factory :job do
    name 'A job'
    short_description 'Watman'
    description 'Watman' * 2
    street 'Bankgatan 14C'
    zip '223 52'
    city 'Lund'
    municipality 'Lund'
    association :owner, factory: :company_user
    association :language
    association :category
    association :hourly_pay
    customer_hourly_price 300.0
    job_date 1.week.from_now
    publish_at 1.day.ago
    hours 30

    factory :job_with_translation do
      transient do
        translation_locale nil
      end

      after(:create) do |job, evaluator|
        translation_attributes = {
          name: job.name,
          description: job.description,
          short_description: job.short_description
        }
        if evaluator.translation_locale
          language = Language.find_or_create_by(lang_code: evaluator.translation_locale)
          job.set_translation(translation_attributes, language)
        else
          job.set_translation(translation_attributes)
        end
      end
    end

    factory :passed_job do
      job_date 7.days.ago
      job_end_date 6.days.ago
      # Since a job can't be screated thats in the passed we need to skip validations
      to_create { |instance| instance.save(validate: false) }
    end

    factory :inprogress_job do
      job_date Time.zone.now - 1.hour
      job_end_date 1.day.from_now
      hours 4
      # Since a job can't be created thats in the passed we need to skip validations
      to_create { |instance| instance.save(validate: false) }
    end

    factory :future_job do
      job_date 1.week.from_now
      job_end_date 2.weeks.from_now
    end

    factory :job_with_comments do
      transient do
        comments_count 1
      end

      after(:create) do |job, evaluator|
        comments = create_list(:comment, evaluator.comments_count)
        job.comments = comments
      end
    end

    factory :job_with_traits do
      transient do
        skills_count 2
        languages_count 2
      end

      after(:create) do |job, evaluator|
        skills = create_list(:skill, evaluator.skills_count)
        job.skills = skills
        languages = create_list(:language, evaluator.languages_count)
        job.languages = languages
      end
    end

    factory :job_with_skills do
      transient do
        skills_count 1
      end

      after(:create) do |job, evaluator|
        skills = create_list(:skill, evaluator.skills_count)
        job.skills = skills
      end
    end

    factory :job_with_languages do
      transient do
        languages_count 1
      end

      after(:create) do |job, evaluator|
        languages = create_list(:language, evaluator.languages_count)
        job.languages = languages
      end
    end

    factory :job_with_users do
      transient do
        users_count 1
      end

      after(:create) do |job, evaluator|
        users = create_list(:user, evaluator.users_count)
        job.users = users
      end
    end

    factory :job_for_docs do
      id 1
      latitude 59.3158558
      longitude 18.0552976
      zip_latitude 59.7117339
      zip_longitude 18.4256286
      swedish_drivers_license 'A,B'

      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
      job_date Time.new(2016, 2, 18, 1, 1, 1).utc
      job_end_date Time.new(2016, 2, 20, 1, 1, 1).utc
      publish_at Time.new(2016, 2, 10, 1, 1, 1).utc
      last_application_at Time.new(2016, 2, 17, 1, 1, 1).utc
      description 'Typewriter hashtag ennui brunch post-ironic food truck vinegar.'
      tasks_description 'Some description in markdown.'
      applicant_description 'Some description in markdown.'
      requirements_description 'Some description in markdown.'
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
#  preview_key                  :string
#  customer_hourly_price        :decimal(, )
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
