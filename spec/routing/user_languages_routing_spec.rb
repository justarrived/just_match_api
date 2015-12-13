require "rails_helper"

RSpec.describe Api::V1::Users::UserLanguagesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/users/1/languages').to route_to('api/v1/users/user_languages#index', user_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/users/1/languages/1').to route_to('api/v1/users/user_languages#show', user_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/users/1/languages').to route_to('api/v1/users/user_languages#create', user_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/users/1/languages/1').to route_to('api/v1/users/user_languages#destroy', user_id: '1', id: '1')
    end
  end
end
