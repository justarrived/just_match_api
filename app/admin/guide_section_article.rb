# frozen_string_literal: true

ActiveAdmin.register GuideSectionArticle do
  permit_params do
    %i[
      order
      language_id
      next_guide_section_article_id
      guide_section_id
    ]
  end
end
