require 'rails_helper'

RSpec.describe "UserSkills", type: :request do
  describe "GET /user_skills" do
    it "works! (now write some real specs)" do
      get user_skills_path
      expect(response).to have_http_status(200)
    end
  end
end
