# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserInterest, type: :model do
  describe '#touched_by_admin?' do
    it 'returns true if level_by_admin is set' do
      user_interest = FactoryGirl.build(:user_interest, level_by_admin: 7)
      expect(user_interest.touched_by_admin?).to eq(true)
    end

    it 'returns false if level_by_admin is not set' do
      user_interest = FactoryGirl.build(:user_interest, level_by_admin: nil)
      expect(user_interest.touched_by_admin?).to eq(false)
    end
  end
end

# == Schema Information
#
# Table name: user_interests
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  interest_id    :integer
#  level          :integer
#  level_by_admin :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_user_interests_on_interest_id  (interest_id)
#  index_user_interests_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_5630a14e4d  (interest_id => interests.id)
#  fk_rails_ec759c020c  (user_id => users.id)
#
