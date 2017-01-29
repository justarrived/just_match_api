# frozen_string_literal: true
class UserInterestSerializer < ApplicationSerializer
  belongs_to :user
  belongs_to :interest

  attributes :level
end
