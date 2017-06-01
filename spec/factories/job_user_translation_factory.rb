# frozen_string_literal: true

FactoryGirl.define do
  factory :job_user_translation do
    locale 'MyString'
    apply_message 'MyText'
    association :job_user
    association :language
  end
end

# == Schema Information
#
# Table name: job_user_translations
#
#  id            :integer          not null, primary key
#  locale        :string
#  apply_message :text
#  job_user_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  language_id   :integer
#
# Indexes
#
#  index_job_user_translations_on_job_user_id  (job_user_id)
#  index_job_user_translations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_907ad55d9d  (language_id => languages.id)
#  fk_rails_a8afd7f71e  (job_user_id => job_users.id)
#
