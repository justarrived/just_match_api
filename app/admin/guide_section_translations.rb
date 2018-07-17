# frozen_string_literal: true

ActiveAdmin.register GuideSectionTranslation do
  menu parent: 'Guide', label: 'Section Translations', priority: 3

  filter :section, collection: -> { GuideSection.with_translations }
  filter :language, collection: -> { Language.system_languages }
  filter :title
  filter :slug
  filter :short_description
  filter :created_at
  filter :updated_at

  permit_params do
    %i[
      title
      short_description
      slug
      locale
      language_id
      guide_section_id
    ]
  end
end
