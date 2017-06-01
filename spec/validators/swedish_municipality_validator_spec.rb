# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SwedishMunicipalityValidator do
  def swedish_municipanity_validator_class(options)
    Class.new(ValidationTester) do
      attr_accessor :municipality

      validates :municipality, swedish_municipality: options

      def municipality_changed?
        true
      end
    end
  end

  describe '#validates_each' do
    let(:options) { true }
    let(:test_model) { swedish_municipanity_validator_class(options).new }

    it 'passes when its a valid Swedish municipality' do
      test_model.municipality = 'Stockholm'

      expect(test_model).to be_valid
    end

    it 'fails when its an unknown Swedish municipality and adds the default error message' do # rubocop:disable Metrics/LineLength
      test_model.municipality = 'wat'
      test_model.valid?

      error_msg = I18n.t('errors.validators.swedish_municipality')
      expect(test_model.errors[:municipality]).to eq([error_msg])
    end

    context 'with a custom error message' do
      let(:custom_message) { 'this is a custom message' }
      let(:options) { { message: custom_message } }

      it 'adds the custom message' do
        test_model.municipality = 'wat'
        test_model.valid?

        expect(test_model.errors[:municipality]).to eq([custom_message])
      end
    end
  end
end
