require 'rails_helper'

RSpec.describe "JobSkills", type: :request do
  describe "GET /job_skills" do
    it "works! (now write some real specs)" do
      get job_skills_path
      expect(response).to have_http_status(200)
    end
  end
end
