require 'rails_helper'

RSpec.describe ReceivedText, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: received_texts
#
#  id          :integer          not null, primary key
#  from_number :string
#  to_number   :string
#  body        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
