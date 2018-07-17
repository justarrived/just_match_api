# frozen_string_literal: true

ActiveAdmin.register Interest do
  menu parent: 'Settings'

  include AdminHelpers::MachineTranslation::Actions

  filter :translations_name_cont, as: :string, label: I18n.t('admin.name')
  filter :internal
  filter :created_at
  filter :updated_at

  set_interest_translation = lambda do |interest, permitted_params|
    return unless interest.persisted? && interest.valid?

    interest.set_translation(name: permitted_params.dig(:interest, :name))
  end

  after_save do |interest|
    set_interest_translation.call(interest, permitted_params)
  end

  permit_params do
    %i(name internal language_id)
  end

  controller do
    def scoped_collection
      super.with_translations
    end
  end
end
