# frozen_string_literal: true


class Activity < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end

# == Schema Information
#
# Table name: activities
#
#  created_at :datetime         not null
#  id         :bigint(8)        not null, primary key
#  name       :string
#  updated_at :datetime         not null
#
