# frozen_string_literal: true
class JobPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.visible
    end
  end

  FULL_ATTRIBUTES = [
    :id, :description, :job_date, :hours, :name, :created_at, :updated_at, :latitude,
    :longitude, :street, :zip, :zip_latitude, :zip_longitude, :verified, :job_end_date,
    :filled, :short_description, :featured, :upcoming, :translated_text, :amount,
    :invoice_amount, :language_id
  ].freeze

  ATTRIBUTES = [
    :id, :description, :job_date, :hours, :name, :created_at, :updated_at, :zip,
    :zip_latitude, :zip_longitude, :verified, :job_end_date, :filled, :short_description,
    :featured, :upcoming, :street, :amount, :invoice_amount, :translated_text,
    :language_id
  ].freeze

  OWNER_ATTRIBUTES = [
    :description, :job_date, :street, :zip, :name, :hours, :job_end_date, :cancelled,
    :filled, :short_description, :featured, :upcoming, :language_id, :category_id,
    :hourly_pay_id, skill_ids: []
  ].freeze

  def index?
    true
  end

  alias_method :show?, :index?
  alias_method :google?, :show?

  def create?
    company_user?
  end

  def update?
    admin? || owner?
  end

  def matching_users?
    admin? || owner?
  end

  # Methods that don't match any controller action

  def permitted_attributes
    return [] if no_user?

    if admin? || !record.persisted? || owner?
      OWNER_ATTRIBUTES
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

  def present_attributes(collection: false)
    return ATTRIBUTES if user.nil? || collection

    if admin? || owner? || accepted_applicant?
      FULL_ATTRIBUTES
    else
      ATTRIBUTES
    end
  end

  def owner?
    record.owner?(user)
  end

  def accepted_applicant?
    record.accepted_applicant?(user)
  end
end
