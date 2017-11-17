# frozen_string_literal: true

class UtalkCodePolicy < ApplicationPolicy
  def create?
    user.present?
  end
end
