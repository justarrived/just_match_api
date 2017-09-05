# frozen_string_literal: true

class OccupationPolicy < ApplicationPolicy
  def index?
    true
  end

  alias_method :show?, :index?
end
