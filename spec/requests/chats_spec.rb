require 'rails_helper'

RSpec.describe 'Chats', type: :request do
  describe 'GET /chats' do
    it 'works! (now write some real specs)' do
      get api_v1_chats_path
      expect(response).to have_http_status(200)
    end
  end
end
