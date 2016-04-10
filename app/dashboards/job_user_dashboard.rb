# frozen_string_literal: true
require 'administrate/base_dashboard'

class JobUserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    job: Field::BelongsTo,
    id: Field::Number,
    accepted: Field::Boolean,
    will_perform: Field::Boolean,
    performed: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user,
    :job,
    :id,
    :accepted,
    :will_perform,
    :performed
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :job,
    :id,
    :accepted,
    :will_perform,
    :performed,
    :rate,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :job,
    :accepted,
    :will_perform,
    :performed
  ].freeze

  # Overwrite this method to customize how job users are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(job_user)
  #   "JobUser ##{job_user.id}"
  # end
end
