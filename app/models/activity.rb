# frozen_string_literal: true

class Activity < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
