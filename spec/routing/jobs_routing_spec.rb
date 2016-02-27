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
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id               :integer          not null, primary key
#  max_rate         :integer
#  description      :text
#  job_date         :datetime
#  performed_accept :boolean          default(FALSE)
#  performed        :boolean          default(FALSE)
#  hours            :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  owner_user_id    :integer
#  latitude         :float
#  longitude        :float
#  name             :string
#  language_id      :integer
#  street           :string
#  zip              :string
#  zip_latitude     :float
#  zip_longitude    :float
#
# Indexes
#
#  index_jobs_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_70cb33aa57  (language_id => languages.id)
#
