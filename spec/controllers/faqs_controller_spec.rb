# frozen_string_literal: true
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
# == Schema Information
#
# Table name: faqs
#
#  id          :integer          not null, primary key
#  answer      :text
#  question    :text
#  language_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_faqs_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_24be635445  (language_id => languages.id)
#
