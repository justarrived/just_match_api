# frozen_string_literal: true
class CompanyPolicy < ApplicationPolicy
  def index?
    true
  end

  alias_method :show?, :index?
  alias_method :create?, :index?
end
