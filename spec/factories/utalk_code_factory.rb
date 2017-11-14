# frozen_string_literal: true

FactoryBot.define do
  factory :utalk_code do
    association :user
    sequence :code { |n| "UTALK-code-#{n}" }
    claimed_at '2017-11-14 17:14:50'
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
