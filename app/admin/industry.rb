# frozen_string_literal: true

ActiveAdmin.register Industry do
  menu parent: 'Settings'

  include AdminHelpers::MachineTranslation::Actions

  set_industry_translation = lambda do |industry, permitted_params|
    return unless industry.persisted? && industry.valid?

    translation_params = { name: permitted_params.dig(:industry, :name) }
    language = Language.find_by(id: permitted_params.dig(:industry, :language_id))
    industry.set_translation(translation_params, language)
  end

  after_save do |industry|
    set_industry_translation.call(industry, permitted_params)
  end

  index do
    selectable_column

    column :id { |industry| link_to("##{industry.id}", admin_industry_path(industry)) }
    column :name do |industry|
      link_to(industry.name, admin_industry_path(industry))
    end
    column :ancestry do |industry|
      parent = industry.parent
      if parent
        link_to(parent.name, admin_industry_path(parent))
      end
    end
    column :updated_at

    actions
  end

  show do |industry|
    attributes_table do
      row :id
      row :name
      row :parent
      row :child_count { industry.descendants.count }
      row :language
      row :updated_at
      row :created_at
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs('Industry') do
      f.input :name
      f.input :parent_id, collection: Industry.all
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
