require 'rails_helper'

RSpec.describe "UserLanguages", type: :request do
  describe "GET /user_languages" do
    it "works! (now write some real specs)" do
      get user_languages_path
      expect(response).to have_http_status(200)
    end
  end
end
