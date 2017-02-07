# frozen_string_literal: true
# == Schema Information
#
# Table name: interests
#
#  id          :integer          not null, primary key
#  name        :string
#  language_id :integer
#  internal    :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_interests_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_4b04e42f8f  (language_id => languages.id)
#

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
