# frozen_string_literal: true

class UserInterest < ApplicationRecord
  LEVEL_RANGE = 1..5

  belongs_to :user
  belongs_to :interest

  validates :interest, presence: true
  validates :user, presence: true
  validates :interest, uniqueness: { scope: :user }
  validates :user, uniqueness: { scope: :interest }
  validates :level, numericality: { only_integer: true }, inclusion: LEVEL_RANGE, allow_nil: true # rubocop:disable Metrics/LineLength
  validates :level_by_admin, numericality: { only_integer: true }, inclusion: LEVEL_RANGE, allow_nil: true # rubocop:disable Metrics/LineLength

  scope :visible, (lambda {
    with_level.joins(:interest).where(interests: { internal: false })
  })
  scope :with_level, (-> { where.not(level: nil) })

  def touched_by_admin?
    !level_by_admin.nil?
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
