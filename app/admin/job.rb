# frozen_string_literal: true
ActiveAdmin.register Job do
  # Create sections on the index screen
  scope :all, default: true
  scope :featured
  scope :visible
  scope :uncancelled
  scope :cancelled
  scope :filled
  scope :unfilled

  # Filterable attributes on the index screen
  filter :name
  filter :company
  filter :owner
  filter :job_date
  filter :job_end_date
  filter :created_at
  filter :featured
  filter :filled
  filter :upcoming
  filter :cancelled
  filter :hidden
  filter :hourly_pay

  # Customize columns displayed on the index screen in the table
  index do
    selectable_column

    column :id
    column :original_name
    column :job_date
    column :job_end_date
    column :hours
    column :featured
    column :filled
    column :upcoming
    column :hidden

    actions
  end

  include AdminHelpers::MachineTranslation::Actions

  after_save do |job|
    translation_params = {
      name: permitted_params.dig(:job, :name),
      description: permitted_params.dig(:job, :description),
      short_description: permitted_params.dig(:job, :short_description)
    }
    job.set_translation(translation_params, job.language_id)
  end

  permit_params do
    extras = [
      :cancelled, :language_id, :hourly_pay_id, :category_id, :owner_user_id, :hidden
    ]
    JobPolicy::FULL_ATTRIBUTES + extras
  end

  controller do
    def scoped_collection
      super.with_translations
    end
  end
end
