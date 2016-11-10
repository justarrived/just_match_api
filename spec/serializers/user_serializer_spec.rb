# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:user, id: '1') }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    ignored = %i(id description competence_text translated_text)
    (UserPolicy::ATTRIBUTES - ignored).each do |attribute|
      it "has #{attribute.to_s.humanize.downcase}" do
        dashed_attribute = attribute.to_s.dasherize
        value = resource.public_send(attribute)
        expect(subject).to have_jsonapi_attribute(dashed_attribute, value)
      end
    end

    it 'has translated_text' do
      dashed_attribute = 'translated_text'.dasherize
      value = {
        'description' => nil,
        'education' => nil,
        'job_experience'.dasherize => nil,
        'competence_text'.dasherize => nil,
        'language_id'.dasherize => nil
      }
      expect(subject).to have_jsonapi_attribute(dashed_attribute, value)
    end

    %w(language languages company user-images).each do |relationship|
      it "has #{relationship} relationship" do
        expect(subject).to have_jsonapi_relationship(relationship)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('users')
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                             :integer          not null, primary key
#  email                          :string
#  phone                          :string
#  description                    :text
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  latitude                       :float
#  longitude                      :float
#  language_id                    :integer
#  anonymized                     :boolean          default(FALSE)
#  password_hash                  :string
#  password_salt                  :string
#  admin                          :boolean          default(FALSE)
#  street                         :string
#  zip                            :string
#  zip_latitude                   :float
#  zip_longitude                  :float
#  first_name                     :string
#  last_name                      :string
#  ssn                            :string
#  company_id                     :integer
#  banned                         :boolean          default(FALSE)
#  job_experience                 :text
#  education                      :text
#  one_time_token                 :string
#  one_time_token_expires_at      :datetime
#  ignored_notifications_mask     :integer
#  frilans_finans_id              :integer
#  frilans_finans_payment_details :boolean          default(FALSE)
#  competence_text                :text
#  current_status                 :integer
#  at_und                         :integer
#  arrived_at                     :date
#  country_of_origin              :string
#  managed                        :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_company_id         (company_id)
#  index_users_on_email              (email) UNIQUE
#  index_users_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#  index_users_on_language_id        (language_id)
#  index_users_on_one_time_token     (one_time_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_45f4f12508  (language_id => languages.id)
#  fk_rails_7682a3bdfe  (company_id => companies.id)
#
