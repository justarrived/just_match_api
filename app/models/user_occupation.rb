# frozen_string_literal: true

class UserOccupation < ApplicationRecord
  belongs_to :occupation, optional: false
  belongs_to :user, optional: false
end

# == Schema Information
#
# Table name: user_occupations
#
#  id                  :integer          not null, primary key
#  occupation_id       :integer
#  user_id             :integer
#  years_of_experience :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_user_occupations_on_occupation_id  (occupation_id)
#  index_user_occupations_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (occupation_id => occupations.id)
#  fk_rails_...  (user_id => users.id)
#
