# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/users'
      expect(get: path).to route_to('api/v1/users#index')
    end

    it 'routes to #show' do
      path = '/api/v1/users/1'
      expect(get: path).to route_to('api/v1/users#show', user_id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/users'
      expect(post: path).to route_to('api/v1/users#create')
    end

    it 'routes to #update via PUT' do
      path = '/api/v1/users/1'
      expect(put: path).to route_to('api/v1/users#update', user_id: '1')
    end

    it 'routes to #update via PATCH' do
      path = '/api/v1/users/1'
      expect(patch: path).to route_to('api/v1/users#update', user_id: '1')
    end

    it 'routes to #images' do
      path = '/api/v1/users/images'
      route_path = 'api/v1/users#images'
      expect(post: path).to route_to(route_path)
    end

    it 'routes to #matching_jobs' do
      path = '/api/v1/users/1/matching-jobs'
      expect(get: path).to route_to('api/v1/users#matching_jobs', user_id: '1')
    end

    it 'routes to #available_notifications' do
      path = '/api/v1/users/1/available-notifications'
      expect(get: path).to route_to('api/v1/users#available_notifications', user_id: '1')
    end

    it 'routes to #notifications' do
      path = '/api/v1/users/notifications'
      expect(get: path).to route_to('api/v1/users#notifications')
    end

    it 'routes to #statuses' do
      path = '/api/v1/users/statuses'
      expect(get: path).to route_to('api/v1/users#statuses')
    end

    it 'routes to #genders' do
      path = '/api/v1/users/genders'
      expect(get: path).to route_to('api/v1/users#genders')
    end

    it 'routes to #missing_traits' do
      path = '/api/v1/users/1/missing-traits'
      expect(get: path).to route_to('api/v1/users#missing_traits', user_id: '1')
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  account_clearing_number          :string
#  account_number                   :string
#  admin                            :boolean          default(FALSE)
#  anonymization_requested_at       :datetime
#  anonymized_at                    :datetime
#  arbetsformedlingen_registered_at :date
#  arrived_at                       :date
#  at_und                           :integer
#  banned                           :boolean          default(FALSE)
#  city                             :string
#  company_id                       :integer
#  competence_text                  :text
#  country_of_origin                :string
#  created_at                       :datetime         not null
#  current_status                   :integer
#  description                      :text
#  education                        :text
#  email                            :string
#  first_name                       :string
#  frilans_finans_id                :integer
#  frilans_finans_payment_details   :boolean          default(FALSE)
#  gender                           :integer
#  id                               :integer          not null, primary key
#  ignored_notifications_mask       :integer
#  interviewed_at                   :datetime
#  interviewed_by_user_id           :integer
#  job_experience                   :text
#  just_arrived_staffing            :boolean          default(FALSE)
#  language_id                      :integer
#  last_name                        :string
#  latitude                         :float
#  linkedin_url                     :string
#  longitude                        :float
#  managed                          :boolean          default(FALSE)
#  next_of_kin_name                 :string
#  next_of_kin_phone                :string
#  one_time_token                   :string
#  one_time_token_expires_at        :datetime
#  password_hash                    :string
#  password_salt                    :string
#  phone                            :string
#  presentation_availability        :text
#  presentation_personality         :text
#  presentation_profile             :text
#  ssn                              :string
#  street                           :string
#  super_admin                      :boolean          default(FALSE)
#  system_language_id               :integer
#  updated_at                       :datetime         not null
#  zip                              :string
#  zip_latitude                     :float
#  zip_longitude                    :float
#
# Indexes
#
#  index_users_on_company_id          (company_id)
#  index_users_on_email               (email) UNIQUE
#  index_users_on_frilans_finans_id   (frilans_finans_id) UNIQUE
#  index_users_on_language_id         (language_id)
#  index_users_on_one_time_token      (one_time_token) UNIQUE
#  index_users_on_system_language_id  (system_language_id)
#
# Foreign Keys
#
#  fk_rails_...                     (company_id => companies.id)
#  fk_rails_...                     (language_id => languages.id)
#  users_interviewed_by_user_id_fk  (interviewed_by_user_id => users.id)
#  users_system_language_id_fk      (system_language_id => languages.id)
#
