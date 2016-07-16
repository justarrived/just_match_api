require 'rails_helper'

RSpec.describe Token, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tokens_on_token    (token)
#  index_tokens_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_ac8a5d0441  (user_id => users.id)
#
