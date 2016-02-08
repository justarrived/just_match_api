class JobPolicy < ApplicationPolicy
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
    if admin?
      admin_params
    elsif !record.persisted? || owner?
      owner_params
    elsif accepted_applicant?
      accepted_applicant_params
    else
      []
    end
  end

  def present_applicants?
    admin? || owner?
  end

  def present_attributes
    attributes = record.attribute_names.map(&:to_sym)
    if admin? || owner? || accepted_applicant?
      attributes
    else
      attributes - [:latitude, :longitude, :performed, :performed_accept]
    end
  end

  # Methods that don't match any controller action

  def owner?
    record.owner?(user)
  end

  def accepted_applicant?
    record.accepted_applicant?(user)
  end

  private

  def admin_params
    owner_params + accepted_applicant_params
  end

  def owner_params
    [
      :max_rate, :performed_accept, :description, :job_date, :street, :zip,
      :name, :hours, :language_id, skill_ids: []
    ]
  end

  def accepted_applicant_params
    [:performed]
  end
end
