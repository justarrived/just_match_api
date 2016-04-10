# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :controller do
  describe 'GET #index' do
    it 'assigns all categories as @categories' do
      category = FactoryGirl.create(:category)
      get :index, {}, {}
      expect(assigns(:categories)).to eq([category])
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
#
# Indexes
#
#  index_categories_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#  index_categories_on_name               (name) UNIQUE
#
