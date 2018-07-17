# frozen_string_literal: true

ActiveAdmin.register CommentTranslation do
  menu parent: 'Misc'

  permit_params do
    %i(body locale)
  end
end
