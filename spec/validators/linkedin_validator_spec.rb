# frozen_string_literal: true
require 'rails_helper'

RSpec.describe LinkedinValidator do
  def linkedin_validator_class(options)
    Class.new(ValidationTester) do
      attr_accessor :linkedin_url

      validates :linkedin_url, linkedin: options

      def linkedin_url_changed?
        true
      end
    end
  end

  describe '#validates_each' do
    let(:options) { true }
    let(:test_model) { linkedin_validator_class(options).new }

    it 'passes when its a valid linkedin_url' do
      test_model.linkedin_url = 'https://linkedin.com/'

      expect(test_model).to be_valid
    end

    it 'fails when its an invalid linkedin_url and adds the default error message' do
      test_model.linkedin_url = 'wat'
      test_model.valid?

      error_msg = I18n.t('errors.validators.linkedin_url')
      expect(test_model.errors[:linkedin_url]).to eq([error_msg])
    end

    context 'with a custom error message' do
      let(:custom_message) { 'this is a custom message' }
      let(:options) { { message: custom_message } }

      it 'adds the custom message' do
        test_model.linkedin_url = 'wat'
        test_model.valid?

        expect(test_model.errors[:linkedin_url]).to eq([custom_message])
      end
    end
  end
end
