# frozen_string_literal: true
FactoryGirl.define do
  factory :user_language do
    association :user
    association :language

    factory :user_language_for_docs do
      proficiency 8
      id 1
      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
    end
  end
end

# == Schema Information
#
# Table name: user_languages
#
#  id          :integer          not null, primary key
#  language_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  proficiency :integer
#
# Indexes
#
#  index_user_languages_on_language_id              (language_id)
#  index_user_languages_on_language_id_and_user_id  (language_id,user_id) UNIQUE
#  index_user_languages_on_user_id                  (user_id)
#  index_user_languages_on_user_id_and_language_id  (user_id,language_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_0be39eaff3  (language_id => languages.id)
#  fk_rails_db4f7502c2  (user_id => users.id)
#
