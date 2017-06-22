# frozen_string_literal: true

ActiveAdmin.register IndustryTranslation do
  menu parent: 'Misc'

  permit_params do
    %i(name locale industry_id language_id)
  end
end
