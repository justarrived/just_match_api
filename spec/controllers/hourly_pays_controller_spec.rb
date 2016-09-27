# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::HourlyPaysController, type: :controller do
  describe 'GET #index' do
    it 'returns hourly pays' do
      hourly_pay = FactoryGirl.create(:hourly_pay, active: true)
      get :index, {}, {}
      expect(assigns(:hourly_pays)).to eq([hourly_pay])
    end
  end

  describe 'GET #show' do
    it 'returns hourly pay' do
      hourly_pay = FactoryGirl.create(:hourly_pay, active: true)
      get :show, { id: hourly_pay.id }, {}
      expect(assigns(:hourly_pay)).to eq(hourly_pay)
    end
  end

  describe 'GET #calculate' do
    let(:valid_attributes) { { gross_salary: 100 } }

    it 'returns calculated salary' do
      get :calculate, valid_attributes, {}

      expect(response.body).to be_jsonapi_response_for('hourly-pays')
      expect(response.body).to be_jsonapi_attribute('gross-salary', 100)
    end
  end
end

# == Schema Information
#
# Table name: hourly_pays
#
#  id           :integer          not null, primary key
#  active       :boolean          default(FALSE)
#  currency     :string           default("SEK")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  gross_salary :integer
#
