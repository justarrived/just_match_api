# frozen_string_literal: true

ActiveAdmin.register GuideSection do
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
