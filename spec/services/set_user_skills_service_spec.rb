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

    it 'set user skills' do
      expect(user.user_skills).to be_empty
      described_class.call(user: user, skill_ids_param: skill_param)
      expect(user.user_skills.first.proficiency).to eq(4)
      expect(user.user_skills.length).to eq(1)
    end
  end
end
