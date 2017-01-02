# frozen_string_literal: true
class Tag < ApplicationRecord
  has_many :user_tags
  has_many :users, through: :user_tags
end

# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  color      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
