# frozen_string_literal: true

ActiveAdmin.register GuideSectionArticleTranslation do
  menu parent: 'Guide', label: 'Article Translations', priority: 4

  filter :article, collection: -> { GuideSectionArticle.with_translations }
  filter :language, collection: -> { Language.system_languages }
  filter :title
  filter :slug
  filter :short_description
  filter :body
  filter :created_at
  filter :updated_at

  index do
    selectable_column

    column :id
    column :title
    column :article
    column :updated_at

    actions
  end

  show do
    attributes_table do
      row :language
      row :article
      row :title
      row :slug
      row :locale
      row :short_description
      row :body { |translation| markdown_to_html(translation.body) }
    end
  end

  permit_params do
    %i[
      title
      slug
      locale
      short_description
      body
      language_id
      guide_section_article_id
    ]
  end

  controller do
    def scoped_collection
      super.includes(:article)
    end
  end
end
