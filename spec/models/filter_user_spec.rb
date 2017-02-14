# frozen_string_literal: true
require 'rails_helper'

RSpec.describe FilterUser, type: :model do
end

# == Schema Information
#
# Table name: filter_users
#
#  id         :integer          not null, primary key
#  filter_id  :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_filter_users_on_filter_id  (filter_id)
#  index_filter_users_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_83e668e52f  (filter_id => filters.id)
#  fk_rails_a8a19036ad  (user_id => users.id)
#
