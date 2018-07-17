# frozen_string_literal: true

ActiveAdmin.register MessageTranslation do
  menu parent: 'Misc'

  permit_params do
    %i(body locale)
  end
end
