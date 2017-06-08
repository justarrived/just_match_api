# frozen_string_literal: true

class UserInterestSerializer < ApplicationSerializer
  belongs_to :user
  belongs_to :interest

  attributes :level
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
#  fk_rails_...  (interest_id => interests.id)
#  fk_rails_...  (user_id => users.id)
#
