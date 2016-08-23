# frozen_string_literal: true
FactoryGirl.define do
  factory :token do
    association :user
    token SecureGenerator.token

    factory :expired_token do
      expires_at Date.new(2016, 1, 1)
    end
  end
end

# == Schema Information
#
# Table name: tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  token      :string
#  expires_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tokens_on_token    (token)
#  index_tokens_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_ac8a5d0441  (user_id => users.id)
#
