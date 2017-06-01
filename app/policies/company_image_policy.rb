# frozen_string_literal: true

class CompanyImagePolicy < ApplicationPolicy
  def show?
    true
  end

  alias_method :create?, :show?
end
