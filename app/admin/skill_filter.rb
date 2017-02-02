# frozen_string_literal: true
ActiveAdmin.register SkillFilter do
  permit_params do
    [:skill_id, :filter_id, :proficiency, :proficiency_by_admin]
  end
end
