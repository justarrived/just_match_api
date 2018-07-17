# frozen_string_literal: true

class RecruiterActivity < ApplicationRecord
  belongs_to :user
  belongs_to :activity
  belongs_to :document, optional: true
end
