# frozen_string_literal: true

ActiveAdmin.register GuideSection do
  menu parent: 'Guide', label: 'Sections', priority: 1

  show do
    attributes_table do
      row :language
      row :order
      row :title
      row :slug
      row :short_description
      row :missing_translations do |translation|
        system_languages = Language.system_languages
        missing = system_languages.map(&:lang_code) - translation.translations.map(&:locale) # rubocop:disable Metrics/LineLength

        safe_join(missing.map do |locale|
          language = system_languages.detect { |lang| lang.lang_code == locale }
          link_to(
            "Create #{language.name} version",
            new_admin_guide_section_translation_path(
              'guide_section_translation[locale]': locale,
              'guide_section_translation[language_id]': language.id,
              'guide_section_translation[guide_section_id]': translation.id # rubocop:disable Metrics/LineLength
            )
          )
        end, ', ')
      end
    end

    active_admin_comments
  end

  after_save do |section|
    if section.persisted? && section.valid?
      section.set_translation(
        title: permitted_params.dig(:guide_section, :title),
        slug: permitted_params.dig(:guide_section, :slug),
        short_description: permitted_params.dig(:guide_section, :short_description)
      )
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs('Section') do
      f.input :language, collection: Language.system_languages
      f.input :order
      f.input :title
      f.input :slug
      f.input :short_description
    end

    f.actions
  end

  permit_params do
    %i[
      order
      language_id
      title
      slug
      short_description
    ]
  end
end
