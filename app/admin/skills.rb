# frozen_string_literal: true

ActiveAdmin.register Skill do
  menu parent: 'Settings'

  include AdminHelpers::MachineTranslation::Actions

  scope :all
  scope :high_priority
  scope :visible

  filter :translations_name_cont, as: :string, label: I18n.t('admin.name')
  filter :internal
  filter :high_priority
  filter :created_at
  filter :updated_at

  index do
    selectable_column

    column :id
    column :high_priority
    column :internal
    column(:name) { |skill| skill_badge(skill: skill) }
    column :updated_at

    actions
  end

  set_skill_translation = lambda do |skill, permitted_params|
    return unless skill.persisted? && skill.valid?

    skill.set_translation(name: permitted_params.dig(:skill, :name))
  end

  after_save do |skill|
    set_skill_translation.call(skill, permitted_params).tap do |result|
      ProcessTranslationJob.perform_later(
        translation: result.translation,
        changed: result.changed_fields
      )
    end
  end

  permit_params do
    %i(name color internal language_id high_priority)
  end

  controller do
    def scoped_collection
      super.with_translations
    end
  end
end
