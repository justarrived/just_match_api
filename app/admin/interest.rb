# frozen_string_literal: true
ActiveAdmin.register Interest do
  menu parent: 'Settings'

  include AdminHelpers::MachineTranslation::Actions

  SET_INTEREST_TRANSLATION = lambda do |interest, permitted_params|
    return unless interest.persisted? && interest.valid?

    interest.set_translation(name: permitted_params.dig(:interest, :name))
  end

  after_save do |interest|
    SET_INTEREST_TRANSLATION.call(interest, permitted_params) if interest.persisted?
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
