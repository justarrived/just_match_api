# frozen_string_literal: true

class UtalkCode < ApplicationRecord
  belongs_to :user, optional: true

  validates :code, presence: true, uniqueness: true

  scope :unclaimed, (-> { where(user: nil, claimed_at: nil) })

  def self.first_unclaimed
    unclaimed.limit(1).first
  end

  def signup_url
    return nil unless user

    params = {
      e: user.email,
      n: user.name,
      c: code
    }

    "https://utalk.com/en/start?#{URI.encode_www_form(params.to_a)}"
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
