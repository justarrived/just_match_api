# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailAddress do
  describe '#valid?' do
    [
      # data, expected
      ['test@example.com', true],
      [' test@example.com     ', true],
      [' test@example.com   ', true],
      ['test@example.com ', true],
      ['  tEsT@EXample.COM ', true],
      ['  TEST@EXAMPLE.cOM ', true],
      [' Test Gu <test@EXAMPLE.cOM> ', true],
      [' Test <TEST@EXAMPLE.cOM> (my test ad)', true],
      ['test@ad.asdcom.com.com', true],
      ['+46735000000', false],
      ['+467350000aa', false],
      ['test@', false]
    ].each do |data|
      email, expected = data

      it "returns #{expected} for #{email}" do
        expect(described_class.valid?(email)).to eq(expected)
      end
    end
  end

  describe '#normalize' do
    [
      'test@example.com',
      ' test@example.com     ',
      ' test@example.com   ',
      'test@example.com ',
      '  tEsT@EXample.COM ',
      '  TEST@EXAMPLE.cOM ',
      ' Test Gu <test@EXAMPLE.cOM> ',
      ' Test <TEST@EXAMPLE.cOM> (my test ad)'
    ].each do |email|
      it "normalizes '#{email}' to 'test@example.com'" do
        expect(described_class.normalize(email)).to eq('test@example.com')
      end
    end

    [
      ['    ', nil],
      ['+46735000000  ', '+46735000000'],
      ['+467350000AA  ', '+467350000aa'],
      ['TEST@  ', 'test@']
    ].each do |value_pair|
      value, expected = value_pair

      it "works well for non-valid email: '#{value}'" do
        expect(described_class.normalize(value)).to eq(expected)
      end
    end

    it 'returns nil if passed nil' do
      expect(described_class.normalize(nil)).to be_nil
    end
  end
end
