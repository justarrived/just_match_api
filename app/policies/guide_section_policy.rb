# frozen_string_literal: true

class GuideSectionPolicy < ApplicationPolicy
  def index?
    true
  end

  alias_method :show?, :index?
end
