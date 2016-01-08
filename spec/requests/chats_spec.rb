require 'rails_helper'

RSpec.describe 'Chats', type: :request do
  describe 'GET /chats' do
    context 'not authorized' do
      it 'returns forbidden' do
        get api_v1_chats_path
        expect(response).to have_http_status(401)
      end
    end
  end
end
