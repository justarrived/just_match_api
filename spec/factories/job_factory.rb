# frozen_string_literal: true
FactoryGirl.define do
  factory :job do
    name 'A job'
    description 'Watman' * 2
    street 'Bankgatan 14C'
    zip '223 52'
    association :owner, factory: :user
    association :language
    association :category
    association :hourly_pay
    job_date 1.week.from_now
    hours 3

    factory :passed_job do
      job_date 1.week.ago
      # Since a job can't be screated thats in the passed we need to skip validations
      to_create { |instance| instance.save(validate: false) }
    end

    factory :inprogress_job do
      job_date Time.zone.now - 1.hour
      hours 4
      # Since a job can't be created thats in the passed we need to skip validations
      to_create { |instance| instance.save(validate: false) }
    end

    factory :future_job do
      job_date 1.week.from_now
    end

    factory :job_with_comments do
      transient do
        comments_count 5
      end

      after(:create) do |job, evaluator|
        comments = create_list(:comment, evaluator.comments_count)
        job.comments = comments
      end
    end

    factory :job_with_skills do
      transient do
        skills_count 5
      end

      after(:create) do |job, evaluator|
        skills = create_list(:skill, evaluator.skills_count)
        job.skills = skills
      end
    end

    factory :job_with_users do
      transient do
        users_count 5
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
      created_at Time.new(2016, 02, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 02, 12, 1, 1, 1).utc
      job_date Time.new(2016, 02, 18, 1, 1, 1).utc
      description 'Typewriter hashtag ennui brunch post-ironic food truck vinegar.'
    end
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id            :integer          not null, primary key
#  description   :text
#  job_date      :datetime
#  hours         :float
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  owner_user_id :integer
#  latitude      :float
#  longitude     :float
#  language_id   :integer
#  street        :string
#  zip           :string
#  zip_latitude  :float
#  zip_longitude :float
#  hidden        :boolean          default(FALSE)
#  category_id   :integer
#  hourly_pay_id :integer
#
# Indexes
#
#  index_jobs_on_category_id    (category_id)
#  index_jobs_on_hourly_pay_id  (hourly_pay_id)
#  index_jobs_on_language_id    (language_id)
#
# Foreign Keys
#
#  fk_rails_1cf0b3b406    (category_id => categories.id)
#  fk_rails_70cb33aa57    (language_id => languages.id)
#  fk_rails_b144fc917d    (hourly_pay_id => hourly_pays.id)
#  jobs_owner_user_id_fk  (owner_user_id => users.id)
#
