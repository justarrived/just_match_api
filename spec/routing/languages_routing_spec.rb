require 'rails_helper'

RSpec.describe Api::V1::LanguagesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/languages'
      expect(get: path).to route_to('api/v1/languages#index')
    end

    it 'routes to #show' do
      path = '/api/v1/languages/1'
      expect(get: path).to route_to('api/v1/languages#show', id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/languages'
      expect(post: path).to route_to('api/v1/languages#create')
    end

    it 'routes to #update via PUT' do
      path = '/api/v1/languages/1'
      expect(put: path).to route_to('api/v1/languages#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      path = '/api/v1/languages/1'
      expect(patch: path).to route_to('api/v1/languages#update', id: '1')
    end

    it 'routes to #destroy' do
      path = '/api/v1/languages/1'
      expect(delete: path).to route_to('api/v1/languages#destroy', id: '1')
    end
  end
end

# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  lang_code  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
