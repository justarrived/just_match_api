require 'rails_helper'

RSpec.describe 'UserSkills', type: :request do
  xdescribe 'GET /user_skills' do
    it 'works!' do
      get api_v1_user_skills_path
      expect(response).to have_http_status(200)
    end
  end
end
