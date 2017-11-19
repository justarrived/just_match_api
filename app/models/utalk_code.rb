# frozen_string_literal: true

class UtalkCode < ApplicationRecord
  belongs_to :user, optional: true

  validates :code, presence: true, uniqueness: true

  scope :unclaimed, (-> { where(user: nil, claimed_at: nil) })

  def self.first_unclaimed
    unclaimed.limit(1).first
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
