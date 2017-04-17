# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :controller do
  describe 'GET #index' do
    it 'only returns insured categories' do
      FactoryGirl.create(:category, insurance_status: :uninsured)
      FactoryGirl.create(:category, insurance_status: :assessment_required)
      category = FactoryGirl.create(:category, insurance_status: :insured)
      get :index
      expect(assigns(:categories)).to eq([category])
    end
  end

  describe 'GET #show' do
    it 'returns category' do
      category = FactoryGirl.create(:category, insurance_status: :insured)
      get :show, params: { id: category.id }
      expect(assigns(:category)).to eq(category)
    end
  end
end

# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id                :integer          not null, primary key
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  frilans_finans_id :integer
#  insurance_status  :integer
#  ssyk              :integer
#
# Indexes
#
#  index_categories_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#  index_categories_on_name               (name) UNIQUE
#
