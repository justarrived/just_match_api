# frozen_string_literal: true
class UserSkill < ApplicationRecord
  PROFICIENCY_RANGE = 1..10

  belongs_to :user
  belongs_to :skill

  validates :skill, presence: true
  validates :user, presence: true
  validates :skill, uniqueness: { scope: :user }
  validates :user, uniqueness: { scope: :skill }

  scope :visible, -> { joins(:skill).where(skills: { internal: false }) }

  def self.safe_create(skill:, user:)
    find_or_create_by(user: user, skill: skill)
  end

  def self.safe_destroy(skill:, user:)
    find_by(user: user, skill: skill)&.destroy!
  end

  def touched_by_admin?
    !proficiency_by_admin.nil?
  end
end

# == Schema Information
#
# Table name: user_skills
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  skill_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  proficiency          :integer
#  proficiency_by_admin :integer
#
# Indexes
#
#  index_user_skills_on_skill_id              (skill_id)
#  index_user_skills_on_skill_id_and_user_id  (skill_id,user_id) UNIQUE
#  index_user_skills_on_user_id               (user_id)
#  index_user_skills_on_user_id_and_skill_id  (user_id,skill_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_59acb6e327  (skill_id => skills.id)
#  fk_rails_fe61b6a893  (user_id => users.id)
#
