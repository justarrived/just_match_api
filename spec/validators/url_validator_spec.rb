# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UrlValidator do
  def url_validator_class(options)
    Class.new(ValidationTester) do
      attr_accessor :url

      validates :url, url: options

      def url_changed?
        true
      end
    end
  end

  describe '#validates_each' do
    let(:options) { true }
    let(:test_model) { url_validator_class(options).new }

    it 'passes when its a valid url' do
      test_model.url = 'https://example.com/'

      expect(test_model).to be_valid
    end

    it 'fails when its an invalid url and adds the default error message' do
      test_model.url = 'wat'
      test_model.valid?

      error_msg = I18n.t('errors.validators.url')
      expect(test_model.errors[:url]).to eq([error_msg])
    end

    context 'with a custom error message' do
      let(:custom_message) { 'this is a custom message' }
      let(:options) { { message: custom_message } }

      it 'adds the custom message' do
        test_model.url = 'wat'
        test_model.valid?

        expect(test_model.errors[:url]).to eq([custom_message])
      end
    end
  end
end
