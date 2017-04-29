# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::PartnerFeeds::JobsController, type: :controller do
  describe 'GET #linkedin' do
    it 'only returns linkedin jobs' do
      job = FactoryGirl.create(:job)
      token = 'nososecret'
      allow(AppSecrets).to receive(:linkedin_sync_key).and_return(token)
      get :linkedin, params: { auth_token: token }
      expect(JSON.parse(response.body)).to eq({})
    end

    it 'returns 401 Unquthorized if an invalid key is passed' do
      job = FactoryGirl.create(:job)
      get :linkedin, params: { auth_token: 'thewrongkey' }
      expect(response.status).to eq(401)
    end

    it 'returns 401 Unquthorized if an no key is passed' do
      job = FactoryGirl.create(:job)
      get :linkedin
      expect(response.status).to eq(401)
    end
  end
end