# frozen_string_literal: true
require 'administrate/base_dashboard'

class JobRequestDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    company_name: Field::String,
    contact_string: Field::String,
    assignment: Field::String,
    job_scope: Field::String,
    job_specification: Field::String,
    language_requirements: Field::String,
    job_at_date: Field::String,
    responsible: Field::String,
    suitable_candidates: Field::String,
    comment: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :company_name,
    :responsible,
    :job_scope
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :company_name,
    :contact_string,
    :assignment,
    :job_scope,
    :job_specification,
    :language_requirements,
    :job_at_date,
    :responsible,
    :suitable_candidates,
    :comment,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :company_name,
    :contact_string,
    :assignment,
    :job_scope,
    :job_specification,
    :language_requirements,
    :job_at_date,
    :responsible,
    :suitable_candidates,
    :comment
  ].freeze

  # Overwrite this method to customize how job skills are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(job_skill)
  #   "JobSkill ##{job_skill.id}"
  # end
end
