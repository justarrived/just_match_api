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
    :id, :first_name, :description, :description_html, :education, :education_html,
    :job_experience, :job_experience_html, :competence_text, :competence_text_html,
    :language_id, :zip, :zip_latitude, :zip_longitude, :primary_role, :translated_text,
    :gender
  ].freeze

  ACCEPTED_APPLICANT_ATTRIBUTES = ATTRIBUTES + [
    :phone, :street, :city, :latitude, :longitude, :email, :last_name
  ].freeze

  SELF_ATTRIBUTES = (ATTRIBUTES + ACCEPTED_APPLICANT_ATTRIBUTES + [
    :created_at, :updated_at, :admin, :anonymized, :ignored_notifications,
    :frilans_finans_payment_details, :ssn, :current_status, :at_und, :arrived_at,
    :country_of_origin, :auth_token, :account_clearing_number, :account_number,
    :skype_username, :next_of_kin_name, :next_of_kin_phone,
    :arbetsformedlingen_registered_at, :just_arrived_staffing
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
  alias_method :create_document?, :show?

  def jobs?
    admin_or_self? || company_user?
  end

  alias_method :ratings?, :jobs?

  def owned_jobs?
    admin_or_self?
  end

  def notifications?
    true
  end

  def statuses?
    true
  end

  def genders?
    true
  end

  def email_suggestion?
    true
  end

  def categories?
    true
  end

  def present_attributes(collection: false)
    return ATTRIBUTES if no_user?

    if admin_or_self?
      SELF_ATTRIBUTES
    elsif !collection && accepted_applicant_for_owner?
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
