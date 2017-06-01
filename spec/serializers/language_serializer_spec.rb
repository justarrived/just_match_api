# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LanguageSerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:language, id: '1') }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    described_class::ATTRIBUTES.each do |attribute|
      it "has #{attribute.to_s.humanize.downcase}" do
        value = resource.public_send(attribute)
        expect(subject).to have_jsonapi_attribute(attribute.to_s, value)
      end
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('languages')
    end
  end
end

# == Schema Information
#
# Table name: languages
#
#  id                  :integer          not null, primary key
#  lang_code           :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  en_name             :string
#  direction           :string
#  local_name          :string
#  system_language     :boolean          default(FALSE)
#  sv_name             :string
#  ar_name             :string
#  fa_name             :string
#  fa_af_name          :string
#  ku_name             :string
#  ti_name             :string
#  ps_name             :string
#  machine_translation :boolean          default(FALSE)
#
# Indexes
#
#  index_languages_on_lang_code  (lang_code) UNIQUE
#
