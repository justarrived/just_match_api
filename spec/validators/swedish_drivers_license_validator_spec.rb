# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SwedishDriversLicenseValidator do
  def drivers_license_validator_class(options)
    Class.new(ValidationTester) do
      attr_accessor :drivers_license

      validates :drivers_license, swedish_drivers_license: options

      def drivers_license_changed?
        true
      end
    end
  end

  describe '#validates_each' do
    let(:options) { true }
    let(:test_model) { drivers_license_validator_class(options).new }

    it 'passes when its a valid drivers_license' do
      test_model.drivers_license = 'A, B'

      expect(test_model).to be_valid
    end

    it 'fails when its an invalid drivers_license and adds the default error message' do
      test_model.drivers_license = 'wat'
      test_model.valid?

      error_msg = I18n.t('errors.validators.drivers_license')
      expect(test_model.errors[:drivers_license]).to eq([error_msg])
    end

    context 'with a custom error message' do
      let(:custom_message) { 'this is a custom message' }
      let(:options) { { message: custom_message } }

      it 'adds the custom message' do
        test_model.drivers_license = 'wat'
        test_model.valid?

        expect(test_model.errors[:drivers_license]).to eq([custom_message])
      end
    end
  end
end
