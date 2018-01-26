# frozen_string_literal: true

ActiveAdmin.register Occupation do
  menu parent: 'Settings'

  include AdminHelpers::MachineTranslation::Actions

  filter :translations_name_cont, as: :string, label: I18n.t('admin.name')
  filter :ancestry, as: :select, collection: -> { Occupation.roots.with_translations }
  filter :created_at
  filter :updated_at

  set_occupation_translation = lambda do |occupation, permitted_params|
    return unless occupation.persisted? && occupation.valid?

    translation_params = { name: permitted_params.dig(:occupation, :name) }
    language = Language.find_by(id: permitted_params.dig(:occupation, :language_id))
    occupation.set_translation(translation_params, language)
  end

  after_save do |occupation|
    set_occupation_translation.call(occupation, permitted_params)
  end

  index do
    selectable_column

    column :id do |occupation|
      link_to("##{occupation.id}", admin_occupation_path(occupation))
    end
    column :name do |occupation|
      link_to(occupation.name, admin_occupation_path(occupation))
    end
    column :ancestry do |occupation|
      parent = occupation.parent
      if parent
        link_to(parent.name, admin_occupation_path(parent))
      end
    end
    column :updated_at

    actions
  end

  show do |occupation|
    attributes_table do
      row :id
      row :name
      row :parent
      row :child_count { occupation.descendants.count }
      row :language
      row :updated_at
      row :created_at
    end

    active_admin_comments
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs('Occupation') do
      f.input :name
      f.input :language, collection: Language.system_languages.order(:en_name)
      f.input :parent_id, collection: Occupation.all
    end

    f.actions
  end

  permit_params do
    %i(name parent_id)
  end

  controller do
    def scoped_collection
      super.with_translations
    end
  end
end
