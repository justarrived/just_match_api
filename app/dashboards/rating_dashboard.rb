# frozen_string_literal: true
require 'administrate/base_dashboard'

class RatingDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    from_user: Field::BelongsTo.with_options(class_name: 'User'),
    to_user: Field::BelongsTo.with_options(class_name: 'User'),
    job: Field::BelongsTo,
    id: Field::Number,
    score: Field::Number,
    comment: Field::HasOne,
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
    :score,
    :from_user,
    :to_user,
    :comment,
    :job
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :from_user,
    :to_user,
    :job,
    :id,
    :score,
    :comment,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :from_user,
    :to_user,
    :job,
    :score,
    :comment,
    :created_at,
    :updated_at
  ].freeze
end
