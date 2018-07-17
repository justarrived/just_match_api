# frozen_string_literal: true

ActiveAdmin.register JobUserTranslation do
  menu parent: 'Misc'

  permit_params do
    %i(apply_message locale)
  end
end
