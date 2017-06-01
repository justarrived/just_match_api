# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSkillSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:user_skill, id: '1') }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    %w(skill user).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('user_skills')
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
