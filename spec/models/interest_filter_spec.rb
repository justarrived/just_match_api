# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InterestFilter, type: :model do
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
#  fk_rails_...  (filter_id => filters.id)
#  fk_rails_...  (interest_id => interests.id)
#
