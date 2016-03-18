# frozen_string_literal: true
class JobPolicy < ApplicationPolicy
  PRIVILEGED_ATTRIBUTES = [:latitude, :longitude, :performed, :performed_accept].freeze

  OWNER_ATTRIBUTES = [
    :max_rate, :performed_accept, :description, :job_date, :street, :zip,
    :name, :hours, :language_id, skill_ids: []
  ].freeze
  ACCEPTED_APPLICANT_ATTRIBUTES = [:performed].freeze
  ADMIN_ATTRIBUTES = (OWNER_ATTRIBUTES + ACCEPTED_APPLICANT_ATTRIBUTES).freeze

  def index?
    true
  end

  alias_method :show?, :index?

  def create?
    user?
  end

  def update?
    admin? || owner? || accepted_applicant?
  end

  def matching_users?
    admin? || owner?
  end

  def permitted_attributes
    return [] if no_user?

    if admin?
      ADMIN_ATTRIBUTES
    elsif !record.persisted? || owner?
      OWNER_ATTRIBUTES
    elsif accepted_applicant?
      ACCEPTED_APPLICANT_ATTRIBUTES
    else
      []
    end
  end

  def present_applicants?
    return false if user.nil?

    admin? || owner?
  end

  def present_self_applicant?
    return false if user.nil?

    accepted_applicant?
  end

  def present_attributes
    attributes = record.attribute_names.map(&:to_sym)
    return attributes - PRIVILEGED_ATTRIBUTES if user.nil?

    if admin? || owner? || accepted_applicant?
      attributes
    else
      attributes - PRIVILEGED_ATTRIBUTES
    end
  end

  # Methods that don't match any controller action

  def owner?
    record.owner?(user)
  end

  def accepted_applicant?
    record.accepted_applicant?(user)
  end
end
