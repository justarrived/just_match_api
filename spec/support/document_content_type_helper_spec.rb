# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DocumentContentTypeHelper do
  valid_content_types = %w(
    application/pdf
    application/msword
    application/zip
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
  )
  invalid_content_types = %w(
    image/jpeg image/png image/gif
    video/mp4 test exe application/json application/octet-stream
    application/x-newton-compatible-pkg
  )

  describe '::valid?' do
    valid_content_types.each do |mime_type|
      it "returns true for valid and accepted content type #{mime_type}" do
        expect(described_class.valid?(mime_type)).to eq(true)
      end
    end

    invalid_content_types.each do |extension|
      it "returns true for valid extension #{extension}" do
        expect(described_class.valid?(extension)).to eq(false)
      end
    end
  end

  describe '::original_filename' do
    it 'returns correct filename for valid a valid content type' do
      extension = described_class.original_filename('application/msword').split('.').last
      expect(extension).to eq('doc')
    end

    it 'returns nil for invalid extension' do
      expect(described_class.original_filename('watman')).to be_nil
    end
  end

  describe '::file_extension' do
    [
      ['application/pdf', '.pdf'],
      ['application/msword', '.doc'],
      ['application/zip', '.docx'],
      ['application/vnd.openxmlformats-officedocument.wordprocessingml.document', '.docx']
    ].each do |test_data|
      content_type, expected_extension = test_data

      it "returns correct file extension for #{content_type} content type" do
        expect(described_class.file_extension(content_type)).to eq(expected_extension)
      end
    end

    invalid_content_types.each do |content_type|
      it 'returns bil for invalid content types' do
        expect(described_class.file_extension(content_type)).to be_nil
      end
    end
  end
end
