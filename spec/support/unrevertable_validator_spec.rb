# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UnrevertableValidator do
  def true_after_validator_class(options)
    Class.new(ValidationTester) do
      attr_accessor :boolean_field

      def boolean_field_changed?
      end

      validates :boolean_field, unrevertable: options
    end
  end

  describe '#validates_each' do
    let(:options) { {} }
    let(:test_model) { true_after_validator_class(options).new }

    context 'passes when' do
      it 'the value is true' do
        allow(test_model).to receive(:boolean_field_changed?).
          and_return(true)

        test_model.boolean_field = true

        expect(test_model).to be_valid
      end
    end

    context 'fails when the field is reverted' do
      it 'adds the default error message' do
        allow(test_model).to receive(:boolean_field_changed?).
          and_return(true)

        test_model.boolean_field = true
        test_model.validate

        test_model.boolean_field = false
        test_model.validate

        error_msg = I18n.t('errors.validators.unrevertable')
        expect(test_model.errors[:boolean_field]).to eq([error_msg])
      end

      context 'with a custom error message' do
        let(:custom_message) { 'this is a custom message' }
        before { options.merge!(message: custom_message) }

        it 'adds the custom message' do
          allow(test_model).to receive(:boolean_field_changed?).
            and_return(true)

          test_model.boolean_field = true
          test_model.validate

          test_model.boolean_field = false
          test_model.validate

          expect(test_model.errors[:boolean_field]).to eq([custom_message])
        end
      end
    end
  end
end
