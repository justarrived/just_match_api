# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ReadStaticFAQ do
  describe 'conforms to the expected schema' do
    it 'has only known categories' do
      described_class.call.each_value do |faqs|
        faqs.each do |faq|
          expect(%w(company newcomer).include?(faq[:category])).to eq(true)
        end
      end
    end

    it 'has question key' do
      described_class.call.each_value do |faqs|
        faqs.each do |faq|
          expect(faq.key?(:question)).to eq(true)
        end
      end
    end

    it 'has answer key' do
      described_class.call.each_value do |faqs|
        faqs.each do |faq|
          expect(faq.key?(:answer)).to eq(true)
        end
      end
    end
  end
end
