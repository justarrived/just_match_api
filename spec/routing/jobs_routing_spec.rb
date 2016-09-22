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
#  id                :integer          not null, primary key
#  description       :text
#  job_date          :datetime
#  hours             :float
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  owner_user_id     :integer
#  latitude          :float
#  longitude         :float
#  language_id       :integer
#  street            :string
#  zip               :string
#  zip_latitude      :float
#  zip_longitude     :float
#  hidden            :boolean          default(FALSE)
#  category_id       :integer
#  hourly_pay_id     :integer
#  verified          :boolean          default(FALSE)
#  job_end_date      :datetime
#  cancelled         :boolean          default(FALSE)
#  filled            :boolean          default(FALSE)
#  short_description :string
#  featured          :boolean          default(FALSE)
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
