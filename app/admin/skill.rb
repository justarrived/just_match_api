# frozen_string_literal: true
ActiveAdmin.register Skill do
  menu parent: 'Settings'

  include AdminHelpers::MachineTranslation::Actions

  index do
    selectable_column

    column :id
    column :internal
    column :name { |skill| skill_badge(skill: skill) }
    column :updated_at

    actions
  end

  SET_SKILL_TRANSLATION = lambda do |skill, permitted_params|
    skill.set_translation(name: permitted_params.dig(:skill, :name))
  end

  after_create do |skill|
    SET_SKILL_TRANSLATION.call(skill, permitted_params).tap do |result|
      EnqueueCheapTranslation.call(result)
    end
  end

  after_save do |skill|
    SET_SKILL_TRANSLATION.call(skill, permitted_params)
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
