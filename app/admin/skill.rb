# frozen_string_literal: true
ActiveAdmin.register Skill do
  menu parent: 'Settings'

  after_save do |skill|
    skill.set_translation(name: permitted_params.dig(:skill, :name))
  end

  permit_params do
    [:name, :color, :internal, :language_id]
  end

  controller do
    def scoped_collection
      super.with_translations
    end
  end
end
