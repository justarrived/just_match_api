# frozen_string_literal: true
ActiveAdmin.register Interest do
  menu parent: 'Settings'

  include AdminHelpers::MachineTranslation::Actions

  after_save do |interest|
    interest.set_translation(name: permitted_params.dig(:interest, :name))
  end

  permit_params do
    [:name, :internal, :language_id]
  end

  controller do
    def scoped_collection
      super.with_translations
    end
  end
end
