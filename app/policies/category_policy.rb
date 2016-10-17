# frozen_string_literal: true
class CategoryPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end
end
