# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'BaseController', type: :request do
  before(:each) do
    FactoryGirl.create(:job, short_description: 'shortdescription')
  end

  describe 'key transform header' do
    context 'with X-API-KEY-TRANSFORM underscore' do
      it 'returns all keys in underscore format' do
        get api_v1_jobs_path, headers: { 'X-API-KEY-TRANSFORM' => 'underscore' }

        parsed_body = JSON.parse(response.body)
        first_data = parsed_body['data'].first
        short_description = first_data.dig('attributes', 'short-description')
        expect(short_description).to eq('shortdescription')
      end
    end

    context 'with X-API-KEY-TRANSFORM dash' do
      it 'returns all keys in dashed/kebab-case format' do
        get api_v1_jobs_path, headers: { 'X-API-KEY-TRANSFORM' => 'dash' }

        parsed_body = JSON.parse(response.body)
        first_data = parsed_body['data'].first
        short_description = first_data.dig('attributes', 'short-description')

        expect(short_description).to eq('shortdescription')
      end

      it 'returns all keys in dashed/kebab-case format by default' do
        get api_v1_jobs_path

        parsed_body = JSON.parse(response.body)
        first_data = parsed_body['data'].first
        short_description = first_data.dig('attributes', 'short-description')

        expect(short_description).to eq('shortdescription')
      end
    end
  end
end
