require 'rails_helper'

RSpec.describe "Languages", type: :request do
  describe "GET /languages" do
    it "works! (now write some real specs)" do
      get languages_path
      expect(response).to have_http_status(200)
    end
  end
end
