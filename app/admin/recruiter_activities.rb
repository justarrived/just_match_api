# frozen_string_literal: true

ActiveAdmin.register RecruiterActivity do
  menu parent: 'Users'

  permit_params do
    [
      :body, :user_id, :author_id, :activity_id, :job_id,
      document_attributes: %i[id document]
    ]
  end

  show do
    attributes_table do
      row :id
      row :activity
      row :user
      row :job
      row :document
      row :updated_at
      row :created_at
      row(:body) { |ra| simple_format(ra.body.to_s) }
    end
  end

  # rubocop:disable Metrics/LineLength
  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    user_id = f.object.user&.id || params[:user_id]
    user_collection = user_id.blank? ? User.regular_users : User.where(id: user_id)
    job_collection = Job.with_translations.all.order(id: :desc).limit(200)

    f.inputs(f.object.display_name) do
      f.input :activity, collection: Activity.order(name: :asc), hint: I18n.t('admin.recruiter_activity.activity_hint')
      f.input :user, collection: user_collection, selected: user_id
      f.input :job, collection: job_collection
      f.input :body
      f.has_many :document, new_record: I18n.t('admin.recruiter_activity.new_document_title') do |b|
        b.input :document, as: :file, hint: I18n.t('admin.recruiter_activity.document_hint')
      end
      f.input :author, collection: User.admins, selected: current_active_admin_user.id
    end

    f.actions
  end
  # rubocop:enable Metrics/LineLength
end
