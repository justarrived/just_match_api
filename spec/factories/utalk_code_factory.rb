# frozen_string_literal: true

FactoryBot.define do
  factory :utalk_code do
    association :user
    sequence(:code) { |n| "UTALK-code-#{n}" }
    claimed_at '2017-11-14 17:14:50'

    factory :unclaimed_utalk_code do
      user nil
      claimed_at nil
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
