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
#  cancelled             :boolean          default(FALSE)
#  draft_sent            :boolean          default(FALSE)
#  signed_by_customer    :boolean          default(FALSE)
#  requirements          :string
#  hourly_pay            :string
#  company_org_no        :string
#  company_email         :string
#  company_phone         :string
#  company_address       :string
#  company_id            :integer
#  delivery_user_id      :integer
#  sales_user_id         :integer
#
# Indexes
#
#  index_job_requests_on_company_id  (company_id)
#
# Foreign Keys
#
#  fk_rails_53030c1fe0               (company_id => companies.id)
#  job_requests_delivery_user_id_fk  (delivery_user_id => users.id)
#  job_requests_sales_user_id_fk     (sales_user_id => users.id)
#
