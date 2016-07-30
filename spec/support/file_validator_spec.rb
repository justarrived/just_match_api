# frozen_string_literal: true

RSpec.describe FileValidator do
  describe 'class methods' do
    describe '#build' do
      it 'returns nil if argument is *not* a file' do
        expect(described_class.build('desc', nil, nil, nil)).to be_nil
      end

      it 'returns instance of FileValidator if argument is a file' do
        expect(described_class.build('desc', File, nil, nil)).to be_a(described_class)
      end
    end
  end

  describe '#name' do
    subject { described_class.new('desc') }

    it 'returns the name of the validator' do
      expect(subject.name).to eq('File (multipart)')
    end
  end

  describe '#validate' do
    subject { described_class.new('desc') }

    it 'returns false for invalid file' do
      expect(subject.validate('')).to eq(false)
    end

    it 'returns true for valid file' do
      fake_upload = Rack::Test::UploadedFile.new('Gemfile')
      expect(subject.validate(fake_upload)).to eq(true)
    end
  end

  describe '#description' do
    subject { described_class.new('desc') }

    it 'returns the description of the validator' do
      expect(subject.description).to eq('Must be a valid file')
    end
  end
end
