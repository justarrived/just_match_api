# frozen_string_literal: true

FactoryBot.define do
  factory :user_occupation do
    association :occupation
    association :user
    years_of_experience 1
    importance 1

    factory :user_occupation_for_docs do
      id 1
      years_of_experience 3
      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
    end
  end
end

# == Schema Information
#
# Table name: user_occupations
#
#  id                  :integer          not null, primary key
#  occupation_id       :integer
#  user_id             :integer
#  years_of_experience :integer
#  importance          :integer
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
