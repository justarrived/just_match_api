# frozen_string_literal: true

ActiveAdmin.register GuideSectionTranslation do
  permit_params do
    %i[
      title
      short_description
      slug
      language_id
      guide_section_id
    ]
  end
end
