# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    first_name 'Jane'
    last_name 'Doe'
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password '1234567890'
    phone '1234567890'
    description 'Watman ' * 2
    street 'Bankgatan 14C'
    zip '223 52'
    association :language

    factory :admin_user do
      admin true
    end

    factory :user_with_skills do
      transient do
        skills_count 5
      end

      after(:create) do |user, evaluator|
        skills = create_list(:skill, evaluator.skills_count)
        user.skills = skills
      end
    end

    factory :user_with_languages do
      transient do
        languages_count 5
      end

      after(:create) do |user, evaluator|
        languages = create_list(:language, evaluator.languages_count)
        user.languages = languages
      end
    end

    factory :user_for_docs do
      id 1
      created_at Time.new(2016, 02, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 02, 12, 1, 1, 1).utc
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  email         :string
#  phone         :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  latitude      :float
#  longitude     :float
#  language_id   :integer
#  anonymized    :boolean          default(FALSE)
#  auth_token    :string
#  password_hash :string
#  password_salt :string
#  admin         :boolean          default(FALSE)
#  street        :string
#  zip           :string
#  zip_latitude  :float
#  zip_longitude :float
#  first_name    :string
#  last_name     :string
#
# Indexes
#
#  index_users_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_45f4f12508  (language_id => languages.id)
#
