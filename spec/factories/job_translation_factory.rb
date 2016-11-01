# frozen_string_literal: true
FactoryGirl.define do
  factory :job_translation do
    locale 'en'
    name 'A job'
    short_description 'Something something, darkside..'
    description 'Something something, something, darkside'
    association :job
  end
end
