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

require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/categories/'
      route_path = 'api/v1/categories#index'
      expect(get: path).to route_to(route_path)
    end
  end
end
