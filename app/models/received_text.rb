# frozen_string_literal: true
class ReceivedText < ApplicationRecord
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
