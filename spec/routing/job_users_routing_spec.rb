# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Jobs::JobUsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/jobs/1/users'
      route_path = 'api/v1/jobs/job_users#index'
      expect(get: path).to route_to(route_path, job_id: '1')
    end

    it 'routes to #show' do
      path = '/api/v1/jobs/1/users/1'
      route_path = 'api/v1/jobs/job_users#show'
      expect(get: path).to route_to(route_path, job_id: '1', job_user_id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/jobs/1/users'
      route_path = 'api/v1/jobs/job_users#create'
      expect(post: path).to route_to(route_path, job_id: '1')
    end

    it 'routes to #update' do
      path = '/api/v1/jobs/1/users/1'
      route_path = 'api/v1/jobs/job_users#update'
      expect(put: path).to route_to(route_path, job_id: '1', job_user_id: '1')
    end

    it 'routes to #destroy' do
      path = '/api/v1/jobs/1/users/1'
      route_path = 'api/v1/jobs/job_users#destroy'
      expect(delete: path).to route_to(route_path, job_id: '1', job_user_id: '1')
    end
  end
end

# == Schema Information
#
# Table name: job_users
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  job_id                :integer
#  accepted              :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  will_perform          :boolean          default(FALSE)
#  accepted_at           :datetime
#  performed             :boolean          default(FALSE)
#  apply_message         :text
#  language_id           :integer
#  application_withdrawn :boolean          default(FALSE)
#  shortlisted           :boolean          default(FALSE)
#  rejected              :boolean          default(FALSE)
#
# Indexes
#
#  index_job_users_on_job_id              (job_id)
#  index_job_users_on_job_id_and_user_id  (job_id,user_id) UNIQUE
#  index_job_users_on_language_id         (language_id)
#  index_job_users_on_user_id             (user_id)
#  index_job_users_on_user_id_and_job_id  (user_id,job_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_548d2d3ba9  (job_id => jobs.id)
#  fk_rails_815844930e  (user_id => users.id)
#  fk_rails_93547d43e9  (language_id => languages.id)
#
