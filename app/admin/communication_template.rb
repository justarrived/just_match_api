# frozen_string_literal: true

ActiveAdmin.register CommunicationTemplate do
  menu parent: 'Settings'

  include AdminHelpers::MachineTranslation::Actions

  index do
    selectable_column

    column :id
    column :category
    column :subject

    actions
  end

  show do
    attributes_table do
      row :id
      row :language
      row :category
      row :subject
      row :body do |c_template|
        simple_format(c_template.body)
      end
      row :translations do |c_template|
        safe_join(c_template.translations.map do |translation|
          link_to(
            translation.locale || 'Original',
            admin_communication_template_translation_path(translation)
          )
        end, ', ')
      end
      row :missing_translations do |c_template|
        system_languages = Language.system_languages
        missing = system_languages.map(&:lang_code) - c_template.translations.map(&:locale) # rubocop:disable Metrics/LineLength

        safe_join(missing.map do |locale|
          language = system_languages.detect { |lang| lang.lang_code == locale }
          link_to(
            "Create #{language.name} version",
            new_admin_communication_template_translation_path(
              'communication_template_translation[locale]': locale,
              'communication_template_translation[language_id]': language.id,
              'communication_template_translation[communication_template_id]': c_template.id # rubocop:disable Metrics/LineLength
            )
          )
        end, ', ')
      end
    end

    active_admin_comments
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs I18n.t('admin.communication_template.form.details') do
      f.input :language, collection: Language.system_languages
      f.input :category, hint: I18n.t('admin.communication_template.form.category_hint')
      f.input :subject, hint: I18n.t('admin.communication_template.form.subject_hint')
      f.input :body, hint: I18n.t('admin.communication_template.form.body_hint')
    end

    span do
      user_variables = User.attribute_names.map { |name| "%{user_#{name}}" }.join(', ')
      job_variables = Job.attribute_names.map { |name| "%{job_#{name}}" }.join(', ')
      "Available variables: #{user_variables}, #{job_variables}."
    end

    f.actions
  end

  set_template_translation = lambda do |template, permitted_params|
    return unless template.persisted? && template.valid?

    params = {
      name: permitted_params.dig(:communication_template, :name),
      subject: permitted_params.dig(:communication_template, :subject),
      body: permitted_params.dig(:communication_template, :body)
    }
    template.set_translation(params, template.language)
  end

  after_save do |template|
    set_template_translation.call(template, permitted_params)
  end

  permit_params do
    %i(language_id category subject body)
  end

  controller do
    def scoped_collection
      super.with_translations
    end
  end
end
