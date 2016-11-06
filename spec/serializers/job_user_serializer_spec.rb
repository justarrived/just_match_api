# frozen_string_literal: true
require 'rails_helper'

RSpec.describe JobUserSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:job_user, id: '1') }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    described_class::ATTRIBUTES.each do |attribute|
      it "has #{attribute.to_s.humanize.downcase}" do
        dashed_attribute = attribute.to_s.dasherize
        value = resource.public_send(attribute)
        expect(subject).to have_jsonapi_attribute(dashed_attribute, value)
      end
    end

    %w(job user).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('job-users')
    end
  end
end

# == Schema Information
#
# Table name: job_users
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  job_id        :integer
#  accepted      :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  will_perform  :boolean          default(FALSE)
#  accepted_at   :datetime
#  performed     :boolean          default(FALSE)
#  apply_message :text
#  language_id   :integer
#
# Indexes
#
#  index_job_users_on_job_id              (job_id)
#  index_job_users_on_job_id_and_user_id  (job_id,user_id) UNIQUE
#  index_job_users_on_language_id         (language_id)
#  index_job_users_on_user_id             (user_id)
#  index_job_users_on_user_id_and_job_id  (user_id,job_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_548d2d3ba9  (job_id => jobs.id)
#  fk_rails_815844930e  (user_id => users.id)
#  fk_rails_93547d43e9  (language_id => languages.id)
#
