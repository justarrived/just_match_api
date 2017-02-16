# frozen_string_literal: true
require 'rails_helper'

RSpec.describe HourlyPaySerializer, type: :serializer do
  context 'Individual Resource Representation' do
    let(:resource) { FactoryGirl.build(:hourly_pay, id: '1') }
    let(:serialization) { JsonApiSerializer.serialize(resource) }

    subject do
      JSON.parse(serialization.to_json)
    end

    # float values causes problems (of course..), igore them
    ignore_values = %i(
      net_salary rate_excluding_vat rate_including_vat
      gross_salary_formatted net_salary_formatted
    )
    (described_class::ATTRIBUTES - ignore_values).each do |attribute|
      it "has #{attribute.to_s.humanize.downcase}" do
        dashed_attribute = attribute.to_s.dasherize
        value = resource.public_send(attribute)
        expect(subject).to have_jsonapi_attribute(dashed_attribute, value)
      end
    end

    it 'has gross_salary_formatted' do
      dashed_attribute = 'gross_salary_formatted'.dasherize
      expect(subject).to have_jsonapi_attribute(dashed_attribute, '100 SEK/h')
    end

    it 'is valid jsonapi format' do
      expect(subject).to be_jsonapi_formatted('hourly-pays')
    end
  end
end

# == Schema Information
#
# Table name: hourly_pays
#
#  id           :integer          not null, primary key
#  active       :boolean          default(FALSE)
#  currency     :string           default("SEK")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  gross_salary :integer
#
