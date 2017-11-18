# frozen_string_literal: true

class UserOccupationSerializer < ApplicationSerializer
  ATTRIBUTES = %i[years_of_experience created_at updated_at]

  attributes ATTRIBUTES

  belongs_to :occupation
  belongs_to :user
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
