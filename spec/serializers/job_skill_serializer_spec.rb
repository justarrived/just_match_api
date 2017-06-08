# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobSkillSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:job_skill, id: '1') }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    %w(job skill).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('job_skills')
    end
  end
end

# == Schema Information
#
# Table name: job_skills
#
#  id                   :integer          not null, primary key
#  job_id               :integer
#  skill_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  proficiency          :integer
#  proficiency_by_admin :integer
#
# Indexes
#
#  index_job_skills_on_job_id               (job_id)
#  index_job_skills_on_job_id_and_skill_id  (job_id,skill_id) UNIQUE
#  index_job_skills_on_skill_id             (skill_id)
#  index_job_skills_on_skill_id_and_job_id  (skill_id,job_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (skill_id => skills.id)
#
