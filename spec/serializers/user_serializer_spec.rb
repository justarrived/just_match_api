# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryBot.build(:user, id: '1', description: nil) }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    ignored = %i(
      id description competence_text competence_text_html translated_text description_html
      education_html job_experience_html
    )
    (UserPolicy::ATTRIBUTES - ignored).each do |attribute|
      it "has #{attribute.to_s.humanize.downcase}" do
        value = resource.public_send(attribute)
        expect(subject).to have_jsonapi_attribute(attribute.to_s, value)
      end
    end

    it 'has translated_text' do
      value = {
        'description' => nil,
        'description_html' => nil,
        'job_experience' => nil,
        'job_experience_html' => nil,
        'education' => nil,
        'education_html' => nil,
        'competence_text' => nil,
        'competence_text_html' => nil,
        'language_id' => nil
      }
      expect(subject).to have_jsonapi_attribute('translated_text', value)
    end

    %w(language languages company user_images occupations).each do |relationship|
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
#  account_clearing_number          :string
#  account_number                   :string
#  admin                            :boolean          default(FALSE)
#  anonymization_requested_at       :datetime
#  anonymized_at                    :datetime
#  arbetsformedlingen_registered_at :date
#  arrived_at                       :date
#  at_und                           :integer
#  banned                           :boolean          default(FALSE)
#  city                             :string
#  company_id                       :integer
#  competence_text                  :text
#  country_of_origin                :string
#  created_at                       :datetime         not null
#  current_status                   :integer
#  description                      :text
#  education                        :text
#  email                            :string
#  first_name                       :string
#  frilans_finans_id                :integer
#  frilans_finans_payment_details   :boolean          default(FALSE)
#  gender                           :integer
#  id                               :integer          not null, primary key
#  ignored_notifications_mask       :integer
#  interviewed_at                   :datetime
#  interviewed_by_user_id           :integer
#  job_experience                   :text
#  just_arrived_staffing            :boolean          default(FALSE)
#  language_id                      :integer
#  last_name                        :string
#  latitude                         :float
#  linkedin_url                     :string
#  longitude                        :float
#  managed                          :boolean          default(FALSE)
#  next_of_kin_name                 :string
#  next_of_kin_phone                :string
#  one_time_token                   :string
#  one_time_token_expires_at        :datetime
#  password_hash                    :string
#  password_salt                    :string
#  phone                            :string
#  presentation_availability        :text
#  presentation_personality         :text
#  presentation_profile             :text
#  ssn                              :string
#  street                           :string
#  super_admin                      :boolean          default(FALSE)
#  system_language_id               :integer
#  updated_at                       :datetime         not null
#  zip                              :string
#  zip_latitude                     :float
#  zip_longitude                    :float
#
# Indexes
#
#  index_users_on_company_id          (company_id)
#  index_users_on_email               (email) UNIQUE
#  index_users_on_frilans_finans_id   (frilans_finans_id) UNIQUE
#  index_users_on_language_id         (language_id)
#  index_users_on_one_time_token      (one_time_token) UNIQUE
#  index_users_on_system_language_id  (system_language_id)
#
# Foreign Keys
#
#  fk_rails_...                     (company_id => companies.id)
#  fk_rails_...                     (language_id => languages.id)
#  users_interviewed_by_user_id_fk  (interviewed_by_user_id => users.id)
#  users_system_language_id_fk      (system_language_id => languages.id)
#
