# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::InterestsController, type: :controller do
  before(:each) do
    allow_any_instance_of(User).to receive(:persisted?).and_return(true)
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all interests as @interests' do
      interest = FactoryGirl.create(:interest)
      process :index, method: :get, headers: valid_session
      expect(assigns(:interests)).to eq([interest])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested interest as @interest' do
      interest = FactoryGirl.create(:interest)
      get :show, params: { id: interest.to_param }, headers: valid_session
      expect(assigns(:interest)).to eq(interest)
    end
  end
end
