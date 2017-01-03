# frozen_string_literal: true
class UserImagePolicy < ApplicationPolicy
  def show?
    admin_or_self?
  end

  def images?
    true
  end

  private

  def admin_or_self?
    admin? || user == record.user
  end
end
