# frozen_string_literal: true
# == Schema Information
#
# Table name: hourly_pays
#
#  id         :integer          not null, primary key
#  active     :boolean          default(FALSE)
#  rate       :integer
#  currency   :string           default("SEK")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Api::V1::FaqsController, type: :controller do
  describe 'GET #index' do
    it 'assigns all faqs as @faqs' do
      hourly_pay = FactoryGirl.create(:faq)
      get :index, {}, {}
      expect(assigns(:faqs)).to eq([hourly_pay])
    end
  end
end
