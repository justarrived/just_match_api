# frozen_string_literal: true
class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.visible
      end
    end
  end

  ATTRIBUTES = [
    :id, :first_name, :description, :job_experience, :education, :language_id, :zip,
    :zip_latitude, :zip_longitude
  ].freeze

  ACCEPTED_APPLICANT_ATTRIBUTES = ATTRIBUTES + [
    :phone, :street, :latitude, :longitude, :email, :last_name
  ].freeze

  SELF_ATTRIBUTES = (ATTRIBUTES + ACCEPTED_APPLICANT_ATTRIBUTES + [
    :created_at, :updated_at, :admin, :auth_token, :anonymized, :ignored_notifications,
    :frilans_finans_payment_details
  ]).freeze

  attr_reader :accepted_applicant

  def index?
    admin?
  end

  def create?
    true
  end

  def show?
    admin_or_self?
  end

  alias_method :update?, :show?
  alias_method :destroy?, :show?
  alias_method :matching_jobs?, :show?
  alias_method :frilans_finans?, :show?
  alias_method :chats?, :show?

  def jobs?
    admin_or_self? || company_user?
  end

  def owned_jobs?
    admin_or_self?
  end

  def notifications?
    true
  end

  def present_attributes
    return ATTRIBUTES if no_user?

    if admin_or_self?
      SELF_ATTRIBUTES
    elsif accepted_applicant_for_owner?
      ACCEPTED_APPLICANT_ATTRIBUTES
    else
      ATTRIBUTES
    end
  end

  private

  def accepted_applicant_for_owner?
    User.accepted_applicant_for_owner?(owner: record, user: user)
  end

  def admin_or_self?
    admin? || user == record
  end
end
