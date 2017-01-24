# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ReceivedText, type: :model do
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
