# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserSkill, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:skill) { FactoryGirl.create(:skill) }

  describe '#touched_by_admin?' do
    it 'returns true if proficiency_by_admin is set' do
      user_skill = FactoryGirl.build(:user_skill, proficiency_by_admin: 7)
      expect(user_skill.touched_by_admin?).to eq(true)
    end

    it 'returns false if proficiency_by_admin is not set' do
      user_skill = FactoryGirl.build(:user_skill, proficiency_by_admin: nil)
      expect(user_skill.touched_by_admin?).to eq(false)
    end
  end

  describe '#safe_create' do
    it 'can create user skill' do
      expect do
        user_skill = described_class.safe_create(skill: skill, user: user)

        expect(user_skill).to be_persisted
      end.to change(described_class, :count).by(1)
    end

    it 'can safely invoke create user skill twice' do
      expect do
        user_skill = described_class.safe_create(skill: skill, user: user)
        described_class.safe_create(skill: skill, user: user)

        expect(user_skill).to be_persisted
      end.to change(described_class, :count).by(1)
    end
  end

  describe '#safe_destroy' do
    it 'can delete user skill' do
      described_class.safe_create(skill: skill, user: user)
      expect do
        described_class.safe_destroy(skill: skill, user: user)
      end.to change(described_class, :count).by(-1)
    end

    it 'can safely invoke delete user skill twice' do
      described_class.safe_create(skill: skill, user: user)
      expect do
        described_class.safe_destroy(skill: skill, user: user)
        described_class.safe_destroy(skill: skill, user: user)
      end.to change(described_class, :count).by(-1)
    end
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
