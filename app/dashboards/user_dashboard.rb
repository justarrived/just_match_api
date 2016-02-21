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
    language: Field::BelongsTo,
    user_skills: Field::HasMany,
    skills: Field::HasMany,
    owned_jobs: Field::HasMany.with_options(class_name: 'Job'),
    job_users: Field::HasMany,
    jobs: Field::HasMany,
    user_languages: Field::HasMany,
    languages: Field::HasMany,
    written_comments: Field::HasMany.with_options(class_name: 'Comment'),
    chat_users: Field::HasMany,
    chats: Field::HasMany,
    messages: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    email: Field::String,
    phone: Field::String,
    description: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    latitude: Field::Number.with_options(decimals: 2),
    longitude: Field::Number.with_options(decimals: 2),
    #   address: Field::String,
    anonymized: Field::Boolean,
    auth_token: Field::String,
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
    :language,
    :user_skills,
    :skills,
    :owned_jobs
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :language,
    :user_skills,
    :skills,
    :owned_jobs,
    :job_users,
    :jobs,
    :user_languages,
    :languages,
    :written_comments,
    :chat_users,
    :chats,
    :messages,
    :id,
    :name,
    :email,
    :phone,
    :description,
    :created_at,
    :updated_at,
    :latitude,
    :longitude,
    # : address,
    :anonymized,
    # :auth_token,
    # :password_hash,
    # :password_salt,
    :admin
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :language,
    :user_skills,
    :skills,
    :owned_jobs,
    :job_users,
    :jobs,
    :user_languages,
    :languages,
    :written_comments,
    :chat_users,
    :chats,
    :messages,
    :name,
    :email,
    :phone,
    :description,
    :latitude,
    :longitude,
    # : address,
    :anonymized,
    # :auth_token,
    # :password_hash,
    # :password_salt,
    :admin
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(user)
    "##{user.id} #{user.name}"
  end
end
