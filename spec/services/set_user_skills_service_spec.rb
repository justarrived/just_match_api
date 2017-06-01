# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SetUserSkillsService do
  describe '::call' do
    let(:user) { FactoryGirl.create(:user) }
    let(:skill) { FactoryGirl.create(:skill) }
    let(:proficiency) { 4 }
    let(:skill_param) do
      [{ id: skill.id, proficiency: proficiency }]
    end
    let(:admin_skill_param) do
      [{ id: skill.id, proficiency_by_admin: proficiency }]
    end

    context 'create' do
      it 'user skills' do
        expect(user.user_skills).to be_empty
        described_class.call(user: user, skill_ids_param: skill_param)
        user.reload
        expect(user.user_skills.first.proficiency).to eq(proficiency)
        expect(user.user_skills.length).to eq(1)
      end
    end

    context 'update' do
      let(:proficiency) { 5 }
      let(:other_skill) { FactoryGirl.create(:skill, id: 13_000) }

      it 'existing skill' do
        expect(user.user_skills).to be_empty
        described_class.call(user: user, skill_ids_param: skill_param)
        user.reload
        expect(user.user_skills.first.proficiency).to eq(proficiency)
        expect(user.user_skills.length).to eq(1)
      end

      it 'can remove existing skill' do
        expect(user.user_skills).to be_empty
        described_class.call(user: user, skill_ids_param: skill_param)
        described_class.call(user: user, skill_ids_param: [])
        user.reload
        expect(user.user_skills.first).to be_nil
      end

      it 'can remove existing skill and add' do
        expect(user.user_skills).to be_empty
        described_class.call(user: user, skill_ids_param: skill_param)
        param = [{ id: other_skill.id, proficiency: 2 }]
        described_class.call(user: user, skill_ids_param: param)
        user.reload
        expect(user.user_skills.length).to eq(1)
        expect(user.user_skills.first.skill_id).to eq(other_skill.id)
      end

      it 'can *not* remove existing skill if proficiency_by_admin is set' do
        expect(user.user_skills).to be_empty
        described_class.call(user: user, skill_ids_param: admin_skill_param)
        param = [{ id: other_skill.id, proficiency: 2 }]
        described_class.call(user: user, skill_ids_param: param)
        user.reload
        expect(user.user_skills.length).to eq(2)
        expect(user.user_skills.first.skill).to eq(skill)
        expect(user.user_skills.last.skill_id).to eq(13_000)
      end
    end
  end
end
