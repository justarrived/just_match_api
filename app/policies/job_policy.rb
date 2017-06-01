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
    :language_id, :gross_amount, :net_amount, :gross_amount_with_currency, :currency,
    :net_amount_with_currency, :city, :gross_amount_delimited, :net_amount_delimited,
    :full_street_address, :description_html, :staffing_job, :direct_recruitment_job,
    :swedish_drivers_license, :car_required, :last_application_at,
    :last_application_at_in_words, :open_for_applications, :starts_in_the_future,
    :full_time
  ].freeze

  ATTRIBUTES = [
    :id, :description, :job_date, :hours, :name, :created_at, :updated_at, :zip,
    :zip_latitude, :zip_longitude, :verified, :job_end_date, :filled, :short_description,
    :featured, :upcoming, :street, :amount, :translated_text, :language_id, :gross_amount,
    :net_amount, :gross_amount_with_currency, :net_amount_with_currency, :city, :currency,
    :gross_amount_delimited, :net_amount_delimited, :full_street_address, :staffing_job,
    :description_html, :direct_recruitment_job, :swedish_drivers_license, :car_required,
    :last_application_at, :last_application_at_in_words, :open_for_applications,
    :starts_in_the_future, :full_time
  ].freeze

  OWNER_ATTRIBUTES = [
    :description, :job_date, :street, :zip, :name, :hours, :job_end_date, :cancelled,
    :city, :filled, :short_description, :featured, :upcoming, :currency,
    :gross_amount_delimited, :net_amount_delimited, :full_street_address, :staffing_job,
    :description_html, :direct_recruitment_job, :owner_user_id, :swedish_drivers_license,
    :car_required, :last_application_at, :full_time,
    :language_id, :category_id, :hourly_pay_id, skill_ids: []
  ].freeze

  def index?
    true
  end

  alias_method :locations?, :index?
  alias_method :show?, :index?
  alias_method :google?, :show?

  def create?
    company_user? || AppConfig.allow_regular_users_to_create_jobs?
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
