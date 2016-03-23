# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AfterTrueValidator do
  def true_after_validator_class(options)
    Class.new(ValidationTester) do
      attr_accessor :first_field, :second_field

      validates :second_field, after_true: options
    end
  end

  describe '#validates_each' do
    let(:options) { { field: :first_field } }
    let(:test_model) { true_after_validator_class(options).new }

    it 'passes when the other field is true' do
      test_model.first_field = true

      expect(test_model).to be_valid
    end

    it 'fails when the other field is false and adds the default error message' do
      test_model.first_field = false
      test_model.valid?

      error_msg = I18n.t('errors.validators.after_true', field: 'first field')
      expect(test_model.errors[:second_field]).to eq([error_msg])
    end

    context 'with a custom error message' do
      let(:custom_message) { 'this is a custom message' }
      before { options.merge!(message: custom_message) }

      it 'adds the custom message' do
        test_model.first_field = false
        test_model.valid?

        expect(test_model.errors[:second_field]).to eq([custom_message])
      end
    end
  end
end
