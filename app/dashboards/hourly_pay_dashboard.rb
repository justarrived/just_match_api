# frozen_string_literal: true
require 'administrate/base_dashboard'

class HourlyPayDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    jobs: Field::HasMany,
    id: Field::Number,
    gross_salary: Field::Number,
    net_salary: Field::Number.with_options(decimals: 2),
    rate_excluding_vat: Field::Number.with_options(decimals: 2),
    rate_including_vat: Field::Number.with_options(decimals: 2),
    active: Field::Boolean,
    currency: Field::String,
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
    :gross_salary,
    :active,
    :jobs
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :jobs,
    :id,
    :gross_salary,
    :net_salary,
    :rate_excluding_vat,
    :rate_including_vat,
    :active,
    :currency,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :jobs,
    :gross_salary,
    :active
  ].freeze

  # Overwrite this method to customize how languages are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(hourly_pay)
    "##{hourly_pay.id} #{hourly_pay.gross_salary}"
  end
end
