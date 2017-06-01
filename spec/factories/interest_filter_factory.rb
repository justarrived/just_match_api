# frozen_string_literal: true

FactoryGirl.define do
  factory :interest_filter do
    association :filter
    association :interest
    level 1
    level_by_admin 1
  end
end

# == Schema Information
#
# Table name: interest_filters
#
#  id             :integer          not null, primary key
#  filter_id      :integer
#  interest_id    :integer
#  level          :integer
#  level_by_admin :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_interest_filters_on_filter_id    (filter_id)
#  index_interest_filters_on_interest_id  (interest_id)
#
# Foreign Keys
#
#  fk_rails_0d27bd670b  (interest_id => interests.id)
#  fk_rails_c6495a7f09  (filter_id => filters.id)
#
