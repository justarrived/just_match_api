require 'rails_helper'

RSpec.describe 'UserLanguages', type: :request do
  describe 'GET /user_languages' do
    it 'works!' do
      user = FactoryGirl.create(:user)
      get api_v1_user_languages_path(user_id: user.to_param)
      expect(response).to have_http_status(200)
    end
  end
end
