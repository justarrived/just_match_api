# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ChatUserSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:chat_user, id: '1') }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    %w(user chat).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('chat-users')
    end
  end
end

# == Schema Information
#
# Table name: chat_users
#
#  id         :integer          not null, primary key
#  chat_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_chat_users_on_chat_id              (chat_id)
#  index_chat_users_on_chat_id_and_user_id  (chat_id,user_id) UNIQUE
#  index_chat_users_on_user_id              (user_id)
#  index_chat_users_on_user_id_and_chat_id  (user_id,chat_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_3953ef352e  (user_id => users.id)
#  fk_rails_86a54ec29b  (chat_id => chats.id)
#
