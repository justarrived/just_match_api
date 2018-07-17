# frozen_string_literal: true

ActiveAdmin.register OccupationTranslation do
  menu parent: 'Misc'

  permit_params do
    %i(name locale occupation_id language_id)
  end
end
