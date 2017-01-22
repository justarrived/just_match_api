# frozen_string_literal: true
ActiveAdmin.register CommunicationTemplate do
  menu parent: 'Settings'

  include AdminHelpers::MachineTranslation::Actions

  form do |f|
    f.semantic_errors

    f.inputs I18n.t('admin.communication_template.form.details') do
      f.input :language
      f.input :category, hint: I18n.t('admin.communication_template.form.category_hint')
      f.input :subject, hint: I18n.t('admin.communication_template.form.subject_hint')
      f.input :body, hint: I18n.t('admin.communication_template.form.body_hint')
    end

    span do
      user_variables = User.attribute_names.map { |name| "${user_#{name}}" }.join(', ')
      job_variables = Job.attribute_names.map { |name| "${job_#{name}}" }.join(', ')
      "Available variables: #{user_variables}, #{job_variables}."
    end

    f.actions
  end

  after_save do |template|
    template.set_translation(
      name: permitted_params.dig(:communication_template, :name),
      subject: permitted_params.dig(:communication_template, :subject),
      body: permitted_params.dig(:communication_template, :body)
    )
  end

  permit_params do
    [:language_id, :category, :subject, :body]
  end

  controller do
    def scoped_collection
      super.with_translations
    end
  end
end
