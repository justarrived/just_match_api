# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::JobsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/jobs').to route_to('api/v1/jobs#index')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/jobs/1').to route_to('api/v1/jobs#show', job_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/jobs').to route_to('api/v1/jobs#create')
    end

    it 'routes to #update via PUT' do
      path = '/api/v1/jobs/1'
      expect(put: path).to route_to('api/v1/jobs#update', job_id: '1')
    end

    it 'routes to #update via PATCH' do
      path = '/api/v1/jobs/1'
      expect(patch: path).to route_to('api/v1/jobs#update', job_id: '1')
    end

    it 'routes to #matching_users via GET' do
      path = '/api/v1/jobs/1/matching-users'
      expect(get: path).to route_to('api/v1/jobs#matching_users', job_id: '1')
    end
  end
end

# == Schema Information
#
# Table name: jobs
#
#  applicant_description              :text
#  blocketjobb_category               :string
#  cancelled                          :boolean          default(FALSE)
#  car_required                       :boolean          default(FALSE)
#  category_id                        :integer
#  city                               :string
#  cloned                             :boolean          default(FALSE)
#  company_contact_user_id            :integer
#  created_at                         :datetime         not null
#  customer_hourly_price              :decimal(, )
#  description                        :text
#  direct_recruitment_job             :boolean          default(FALSE)
#  featured                           :boolean          default(FALSE)
#  filled_at                          :datetime
#  full_time                          :boolean          default(FALSE)
#  hidden                             :boolean          default(FALSE)
#  hourly_pay_id                      :integer
#  hours                              :float
#  id                                 :integer          not null, primary key
#  invoice_comment                    :text
#  job_date                           :datetime
#  job_end_date                       :datetime
#  just_arrived_contact_user_id       :integer
#  language_id                        :integer
#  last_application_at                :datetime
#  latitude                           :float
#  longitude                          :float
#  metrojobb_category                 :string
#  municipality                       :string
#  name                               :string
#  number_to_fill                     :integer          default(1)
#  order_id                           :integer
#  owner_user_id                      :integer
#  preview_key                        :string
#  publish_at                         :datetime
#  publish_on_blocketjobb             :boolean          default(FALSE)
#  publish_on_linkedin                :boolean          default(FALSE)
#  publish_on_metrojobb               :boolean          default(FALSE)
#  published_on_arbetsformedlingen_at :datetime
#  requirements_description           :text
#  salary_type                        :integer          default("fixed")
#  short_description                  :string
#  staffing_company_id                :integer
#  staffing_job                       :boolean          default(FALSE)
#  street                             :string
#  swedish_drivers_license            :string
#  tasks_description                  :text
#  unpublish_at                       :datetime
#  upcoming                           :boolean          default(FALSE)
#  updated_at                         :datetime         not null
#  zip                                :string
#  zip_latitude                       :float
#  zip_longitude                      :float
#
# Indexes
#
#  index_jobs_on_category_id          (category_id)
#  index_jobs_on_hourly_pay_id        (hourly_pay_id)
#  index_jobs_on_language_id          (language_id)
#  index_jobs_on_order_id             (order_id)
#  index_jobs_on_staffing_company_id  (staffing_company_id)
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
