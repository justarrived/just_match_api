# frozen_string_literal: true
ActiveAdmin.register InterestTranslation do
  menu parent: 'Misc'

  permit_params do
    [:name, :locale, :language_id, :interest_id]
  end
end
