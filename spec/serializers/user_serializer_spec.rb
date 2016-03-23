# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:user) }

    let(:serializer) { UserSerializer.new(resource) }
    let(:serialization) { ActiveModel::Serializer::Adapter.create(serializer) }

    subject do
      JSON.parse(serialization.to_json)['data']
    end

    it 'has a name' do
      expect(subject['attributes']['first_name']).to eql(resource.first_name)
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string
#  phone                     :string
#  description               :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  latitude                  :float
#  longitude                 :float
#  language_id               :integer
#  anonymized                :boolean          default(FALSE)
#  auth_token                :string
#  password_hash             :string
#  password_salt             :string
#  admin                     :boolean          default(FALSE)
#  street                    :string
#  zip                       :string
#  zip_latitude              :float
#  zip_longitude             :float
#  first_name                :string
#  last_name                 :string
#  ssn                       :string
#  company_id                :integer
#  banned                    :boolean          default(FALSE)
#  job_experience            :text
#  education                 :text
#  one_time_token            :string
#  one_time_token_expires_at :datetime
#
# Indexes
#
#  index_users_on_auth_token   (auth_token) UNIQUE
#  index_users_on_company_id   (company_id)
#  index_users_on_email        (email) UNIQUE
#  index_users_on_language_id  (language_id)
#  index_users_on_ssn          (ssn) UNIQUE
#
# Foreign Keys
#
#  fk_rails_45f4f12508  (language_id => languages.id)
#  fk_rails_7682a3bdfe  (company_id => companies.id)
#
