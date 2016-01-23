require "administrate/base_dashboard"

class JobDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    language: Field::BelongsTo,
    job_skills: Field::HasMany,
    skills: Field::HasMany,
    job_users: Field::HasMany,
    users: Field::HasMany,
    comments: Field::HasMany,
    owner: Field::BelongsTo.with_options(class_name: "User"),
    id: Field::Number,
    max_rate: Field::Number,
    description: Field::Text,
    job_date: Field::DateTime,
    performed_accept: Field::Boolean,
    performed: Field::Boolean,
    hours: Field::Number.with_options(decimals: 2),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    owner_user_id: Field::Number,
    latitude: Field::Number.with_options(decimals: 2),
    longitude: Field::Number.with_options(decimals: 2),
    address: Field::String,
    name: Field::String,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :language,
    :job_skills,
    :skills,
    :job_users,
  ]

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
    :hours,
    :created_at,
    :updated_at,
    :owner_user_id,
    :latitude,
    :longitude,
    :address,
    :name,
  ]

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
    :hours,
    :owner_user_id,
    :latitude,
    :longitude,
    :address,
    :name,
  ]

  # Overwrite this method to customize how jobs are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(job)
  #   "Job ##{job.id}"
  # end
end
