# frozen_string_literal: true

ActiveAdmin.register UserSkill do
  menu parent: 'Users'

  filter :skill, collection: -> { Skill.with_translations.order_by_name }
  filter :proficiency
  filter :proficiency_by_admin
  filter :updated_at
  filter :created_at

  index do
    selectable_column

    column :id
    column :name do |user_skills|
      skill = user_skills.skill

      link_to(
        skill.name,
        admin_users_path + AdminHelpers::Link.query(:user_skills_skill_id, skill.id)
      )
    end
    column :proficiency
    column :proficiency_by_admin
    column :user
    column :created_at

    actions
  end

  permit_params do
    %i(user_id skill_id proficiency proficiency_by_admin)
  end

  controller do
    def scoped_collection
      super.includes(:user, skill: %i(translations language))
    end
  end
end
