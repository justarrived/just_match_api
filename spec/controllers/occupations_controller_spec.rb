# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::OccupationsController, type: :controller do
  describe 'GET #index' do
    it 'assigns all occupations as @occupations' do
      occupation = FactoryGirl.create(:occupation)
      get :index
      expect(assigns(:occupations)).to eq([occupation])
      expect(response.status).to eq(200)
    end

    it 'is able to filter out all root occupations' do
      occupation = FactoryGirl.create(:occupation)
      FactoryGirl.create(:occupation, parent: occupation)
      get :index, params: { filter: { parent_id: nil } }
      expect(assigns(:occupations)).to eq([occupation])
      expect(response.status).to eq(200)
    end

    it 'is able to filter out children occupations of a specific occupation' do
      occupation1 = FactoryGirl.create(:occupation)
      occupation2 = FactoryGirl.create(:occupation, parent: occupation1)
      FactoryGirl.create(:occupation, parent: occupation2)
      FactoryGirl.create(:occupation)

      get :index, params: { filter: { parent_id: occupation1.to_param } }
      expect(assigns(:occupations)).to eq([occupation2])
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested occupation as @occupations' do
      occupation = FactoryGirl.create(:occupation)
      get :show, params: { id: occupation.to_param }
      expect(assigns(:occupation)).to eq(occupation)
      expect(response.status).to eq(200)
    end
  end
end

# == Schema Information
#
# Table name: occupations
#
#  id          :integer          not null, primary key
#  name        :string
#  ancestry    :string
#  language_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_occupations_on_ancestry     (ancestry)
#  index_occupations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
