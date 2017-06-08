# frozen_string_literal: true

class SkillFilter < ApplicationRecord
  belongs_to :filter
  belongs_to :skill
end

# == Schema Information
#
# Table name: skill_filters
#
#  id                   :integer          not null, primary key
#  filter_id            :integer
#  skill_id             :integer
#  proficiency          :integer
#  proficiency_by_admin :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_skill_filters_on_filter_id  (filter_id)
#  index_skill_filters_on_skill_id   (skill_id)
#
# Foreign Keys
#
#  fk_rails_...               (filter_id => filters.id)
#  skill_filters_skill_id_fk  (skill_id => skills.id)
#
