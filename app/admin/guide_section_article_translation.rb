# frozen_string_literal: true

ActiveAdmin.register GuideSectionArticleTranslation do
  permit_params do
    %i[
      title
      slug
      short_description
      body
      language_id
      guide_section_article_id
    ]
  end
end
