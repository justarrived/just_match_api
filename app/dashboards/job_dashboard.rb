# frozen_string_literal: true
require 'administrate/base_dashboard'

class JobDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    language: Field::BelongsTo,
    company: Field::BelongsTo,
    job_skills: Field::HasMany,
    skills: Field::HasMany,
    job_users: Field::HasMany,
    users: Field::HasMany,
    comments: Field::HasMany,
    owner: Field::BelongsTo.with_options(class_name: 'User'),
    id: Field::Number,
    max_rate: Field::Number,
    description: Field::Text,
    job_date: Field::DateTime,
    performed_accept: Field::Boolean,
    performed: Field::Boolean,
    hidden: Field::Boolean,
    hours: Field::Number.with_options(decimals: 2),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    zip: Field::String,
    street: Field::String,
    latitude: Field::Number.with_options(decimals: 2),
    longitude: Field::Number.with_options(decimals: 2),
    name: Field::String
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :company,
    :language,
    :skills,
    :users,
    :id
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :language,
    :job_skills,
    :skills,
    :job_users,
    :users,
    :comments,
    :owner,
    :id,
    :max_rate,
    :description,
    :job_date,
    :performed_accept,
    :performed,
    :hidden,
    :hours,
    :created_at,
    :updated_at,
    :zip,
    :street,
    :latitude,
    :longitude,
    :name
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :language,
    :job_skills,
    :skills,
    :job_users,
    :users,
    :comments,
    :owner,
    :max_rate,
    :description,
    :job_date,
    :performed_accept,
    :performed,
    :hidden,
    :hours,
    :street,
    :zip,
    :latitude,
    :longitude,
    :name
  ].freeze

  # Overwrite this method to customize how jobs are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(job)
    "##{job.id} #{job.name}"
  end
end
