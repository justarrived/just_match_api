# frozen_string_literal: true
require 'administrate/base_dashboard'

class LanguageDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user_languages: Field::HasMany,
    users: Field::HasMany,
    jobs: Field::HasMany,
    id: Field::Number,
    lang_code: Field::String,
    en_name: Field::String,
    direction: Field::String,
    local_name: Field::String,
    system_language: Field::Boolean,
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
    :lang_code,
    :en_name,
    :system_language,
    :users,
    :jobs
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :lang_code,
    :en_name,
    :direction,
    :local_name,
    :system_language,
    :created_at,
    :updated_at,
    :user_languages,
    :users,
    :jobs
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :lang_code,
    :en_name,
    :direction,
    :local_name,
    :system_language,
    :user_languages,
    :users,
    :jobs
  ].freeze

  # Overwrite this method to customize how languages are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(language)
    "##{language.id} #{language.lang_code}"
  end
end
