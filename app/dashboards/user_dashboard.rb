# frozen_string_literal: true
require 'administrate/base_dashboard'

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    frilans_finans_id: Field::Number,
    language: Field::BelongsTo,
    company: Field::BelongsTo,
    user_skills: Field::HasMany,
    skills: Field::HasMany,
    owned_jobs: Field::HasMany.with_options(class_name: 'Job'),
    job_users: Field::HasMany,
    auth_tokens: Field::HasMany.with_options(class_name: 'Token'),
    jobs: Field::HasMany,
    user_languages: Field::HasMany,
    languages: Field::HasMany,
    written_comments: Field::HasMany.with_options(class_name: 'Comment'),
    chat_users: Field::HasMany,
    chats: Field::HasMany,
    messages: Field::HasMany,
    id: Field::Number,
    first_name: Field::String,
    last_name: Field::String,
    email: Field::String,
    phone: Field::String,
    zip: Field::String,
    ssn: Field::String,
    description: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    zip_latitude: Field::Number.with_options(decimals: 5),
    zip_longitude: Field::Number.with_options(decimals: 5),
    latitude: Field::Number.with_options(decimals: 5),
    longitude: Field::Number.with_options(decimals: 5),
    street: Field::String,
    anonymized: Field::Boolean,
    banned: Field::Boolean,
    password_hash: Field::String,
    password_salt: Field::String,
    admin: Field::Boolean
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :frilans_finans_id,
    :first_name,
    :last_name,
    :language,
    :owned_jobs,
    :job_users
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :first_name,
    :last_name,
    :email,
    :phone,
    :company,
    :language,
    :owned_jobs,
    :job_users,
    :auth_tokens,
    :jobs,
    :user_languages,
    :languages,
    :written_comments,
    :chat_users,
    :chats,
    :messages,
    :id,
    :frilans_finans_id,
    :description,
    :created_at,
    :updated_at,
    :latitude,
    :longitude,
    :zip_latitude,
    :zip_longitude,
    :street,
    :zip,
    :ssn,
    :anonymized,
    :banned,
    :admin,
    :user_skills,
    :skills
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :first_name,
    :last_name,
    :email,
    :language,
    :company,
    :owned_jobs,
    :job_users,
    :auth_tokens,
    :jobs,
    :user_languages,
    :languages,
    :written_comments,
    :chat_users,
    :chats,
    :messages,
    :phone,
    :description,
    :latitude,
    :longitude,
    :zip_latitude,
    :zip_longitude,
    :street,
    :zip,
    :ssn,
    :anonymized,
    :banned,
    :frilans_finans_id,
    :admin,
    :user_skills,
    :skills
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(user)
    "##{user.id} #{user.name}"
  end
end
