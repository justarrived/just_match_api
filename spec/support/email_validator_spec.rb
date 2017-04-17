# frozen_string_literal: true
require 'rails_helper'

RSpec.describe EmailValidator do
  def email_validator_class(options)
    Class.new(ValidationTester) do
      attr_accessor :email

      validates :email, email: options

      def email_changed?
        true
      end
    end
  end

  describe '#validates_each' do
    let(:options) { true }
    let(:test_model) { email_validator_class(options).new }

    it 'passes when its a valid email' do
      test_model.email = 'test@example.com'

      expect(test_model).to be_valid
    end

    it 'fails when its an invalid email and adds the default error message' do
      test_model.email = 'wat'
      test_model.valid?

      error_msg = I18n.t('errors.validators.email')
      expect(test_model.errors[:email]).to eq([error_msg])
    end

    context 'with a custom error message' do
      let(:custom_message) { 'this is a custom message' }
      let(:options) { { message: custom_message } }

      it 'adds the custom message' do
        test_model.email = 'wat'
        test_model.valid?

        expect(test_model.errors[:email]).to eq([custom_message])
      end
    end
  end
end
