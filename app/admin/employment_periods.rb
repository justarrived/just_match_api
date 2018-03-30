# frozen_string_literal: true

ActiveAdmin.register EmploymentPeriod do
  menu parent: 'Users'

  filter :started_at
  filter :ended_at
  filter :percentage
  filter :employer_signed_at
  filter :employee_signed_at

  index do
    selectable_column

    column :id
    column :user
    column :job
    column :started_at
    column :ended_at
    column(:percentage) { |emp| "#{emp.percentage}%" if emp.percentage }

    actions
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs '*' do
      f.input :job, collection: Job.with_translations
      f.input :user
      f.input :started_at, as: :datetime_picker
      f.input :ended_at, as: :datetime_picker
      f.input :percentage
      f.input :employer_signed_at, as: :datetime_picker
      f.input :employee_signed_at, as: :datetime_picker
    end

    f.actions
  end

  permit_params do
    %i[
      job_id
      user_id
      employer_signed_at
      employee_signed_at
      started_at
      ended_at
      percentage
    ]
  end
end
