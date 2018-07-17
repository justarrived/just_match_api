# frozen_string_literal: true

class GuideSectionArticlePolicy < ApplicationPolicy
  def index?
    true
  end

  alias_method :show?, :index?
end
