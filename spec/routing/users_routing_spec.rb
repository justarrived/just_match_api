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

    it 'routes to #destroy' do
      path = '/api/v1/users/1'
      expect(delete: path).to route_to('api/v1/users#destroy', user_id: '1')
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  email         :string
#  phone         :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  latitude      :float
#  longitude     :float
#  language_id   :integer
#  anonymized    :boolean          default(FALSE)
#  auth_token    :string
#  password_hash :string
#  password_salt :string
#  admin         :boolean          default(FALSE)
#  street        :string
#  zip           :string
#  zip_latitude  :float
#  zip_longitude :float
#  first_name    :string
#  last_name     :string
#  ssn           :string
#
# Indexes
#
#  index_users_on_auth_token   (auth_token) UNIQUE
#  index_users_on_email        (email) UNIQUE
#  index_users_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_45f4f12508  (language_id => languages.id)
#
