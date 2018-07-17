# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::InterestsController, type: :controller do
  describe 'GET #index' do
    it 'assigns all interests as @interests' do
      interest = FactoryBot.create(:interest)
      process :index, method: :get
      expect(assigns(:interests)).to eq([interest])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested interest as @interest' do
      interest = FactoryBot.create(:interest)
      get :show, params: { id: interest.to_param }
      expect(assigns(:interest)).to eq(interest)
    end
  end
end

# == Schema Information
#
# Table name: interests
#
#  id          :integer          not null, primary key
#  name        :string
#  language_id :integer
#  internal    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_interests_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
