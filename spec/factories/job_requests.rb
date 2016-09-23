# frozen_string_literal: true
FactoryGirl.define do
  factory :job_request do
    company_name 'MyString'
    contact_string 'MyString'
    assignment 'MyString'
    job_scope 'MyString'
    job_specification 'MyString'
    language_requirements 'MyString'
    job_at_date 'MyString'
    responsible 'MyString'
    suitable_candidates 'MyString'
    comment 'MyString'
  end
end

# == Schema Information
#
# Table name: job_requests
#
#  id                    :integer          not null, primary key
#  company_name          :string
#  contact_string        :string
#  assignment            :string
#  job_scope             :string
#  job_specification     :string
#  language_requirements :string
#  job_at_date           :string
#  responsible           :string
#  suitable_candidates   :string
#  comment               :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  short_name            :string
#  finished              :boolean          default(FALSE)
#
