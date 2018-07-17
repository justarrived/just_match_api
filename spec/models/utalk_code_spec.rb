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

  describe '#signup_url' do
    it 'returns nil if there is no user' do
      utalk = FactoryBot.build_stubbed(:utalk_code, user: nil)
      expect(utalk.signup_url).to be_nil
    end

    it 'returns the correct signup URL for the user' do
      code = 'watman'
      user = FactoryBot.build_stubbed(:user)
      utalk = FactoryBot.build_stubbed(:utalk_code, user: user, code: code)

      escaped_email = CGI.escape(user.email)
      escaped_name = CGI.escape(user.name)

      expected = "https://utalk.com/en/start?e=#{escaped_email}&n=#{escaped_name}&c=#{code}" # rubocop:disable Metrics/LineLength
      expect(utalk.signup_url).to eq(expected)
    end
  end
end

# == Schema Information
#
# Table name: utalk_codes
#
#  id         :bigint(8)        not null, primary key
#  code       :string
#  user_id    :bigint(8)
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
