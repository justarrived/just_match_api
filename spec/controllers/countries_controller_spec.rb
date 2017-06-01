# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::CountriesController, type: :controller do
  describe 'GET #index' do
    it 'renders countries' do
      get :index
      body = JSON.parse(response.body)
      first_country = body.fetch('data').first
      first_country_attrs = first_country.fetch('attributes')

      id = first_country.fetch('id')
      country_code = first_country_attrs.fetch('country_code')
      name = first_country_attrs.fetch('name')

      expect(id).to eq('AF')
      expect(country_code).to eq('AF')
      expect(name).to eq('Afghanistan')
    end
  end
end
