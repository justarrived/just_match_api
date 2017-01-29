# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserInterestSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:user_interest) }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    %w(interest user).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('user-interests')
    end
  end
end

# == Schema Information
#
# Table name: user_interests
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  interest_id    :integer
#  level          :integer
#  level_by_admin :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_user_interests_on_interest_id  (interest_id)
#  index_user_interests_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_5630a14e4d  (interest_id => interests.id)
#  fk_rails_ec759c020c  (user_id => users.id)
#
