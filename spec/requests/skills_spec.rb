require 'rails_helper'

RSpec.describe "Skills", type: :request do
  describe "GET /skills" do
    it "works!" do
      get api_v1_skills_path
      expect(response).to have_http_status(200)
    end
  end
end
