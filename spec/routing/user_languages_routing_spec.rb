# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::UserLanguagesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/users/1/languages'
      route_path = 'api/v1/users/user_languages#index'
      expect(get: path).to route_to(route_path, user_id: '1')
    end

    it 'routes to #show' do
      path = '/api/v1/users/1/languages/1'
      route_path = 'api/v1/users/user_languages#show'
      expect(get: path).to route_to(route_path, user_id: '1', user_language_id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/users/1/languages'
      route_path = 'api/v1/users/user_languages#create'
      expect(post: path).to route_to(route_path, user_id: '1')
    end

    it 'routes to #destroy' do
      path = '/api/v1/users/1/languages/1'
      route_path = 'api/v1/users/user_languages#destroy'
      expect(delete: path).to route_to(route_path, user_id: '1', user_language_id: '1')
    end
  end
end

# == Schema Information
#
# Table name: user_languages
#
#  id                   :integer          not null, primary key
#  language_id          :integer
#  user_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  proficiency          :integer
#  proficiency_by_admin :integer
#
# Indexes
#
#  index_user_languages_on_language_id              (language_id)
#  index_user_languages_on_language_id_and_user_id  (language_id,user_id) UNIQUE
#  index_user_languages_on_user_id                  (user_id)
#  index_user_languages_on_user_id_and_language_id  (user_id,language_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_0be39eaff3  (language_id => languages.id)
#  fk_rails_db4f7502c2  (user_id => users.id)
#
