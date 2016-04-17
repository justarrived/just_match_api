# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Currency, type: :model do
  it 'can return default currency' do
    currency = FactoryGirl.create(:swe_currency)
    expect(described_class.default_currency).to eq(currency)
  end
end

# == Schema Information
#
# Table name: currencies
#
#  id                :integer          not null, primary key
#  currency_code     :string
#  frilans_finans_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
