# frozen_string_literal: true
require 'administrate/base_dashboard'

class InvoiceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    frilans_finans_id: Field::Number,
    job_user: Field::BelongsTo,
    job: Field::HasOne,
    user: Field::HasOne,
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
    :frilans_finans_id,
    :job_user,
    :job,
    :user
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :frilans_finans_id,
    :job_user,
    :job,
    :user,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :job_user,
    :job,
    :user,
    :frilans_finans_id
  ].freeze

  def display_resource(invoice)
    "##{invoice.id} Invoice"
  end
end
