# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UtalkCode, type: :model do
  describe '::first_unclaimed' do
    it 'returns the first unclaimed code' do
      FactoryBot.create(:utalk_code, user: FactoryBot.create(:user))
      utalk_code = FactoryBot.create(:unclaimed_utalk_code)

      expect(described_class.first_unclaimed).to eq(utalk_code)
    end

    it 'returns nil if there are no unclaimed code' do
      FactoryBot.create(:utalk_code, user: FactoryBot.create(:user))
      expect(described_class.first_unclaimed).to be_nil
    end
  end
end

# == Schema Information
#
# Table name: utalk_codes
#
#  id         :integer          not null, primary key
#  code       :string
#  user_id    :integer
#  claimed_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_utalk_codes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
