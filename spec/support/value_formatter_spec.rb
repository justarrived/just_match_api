# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ValueFormatter do
  describe '#text_to_html' do
    [
      ['', nil],
      ['   ', nil],
      [nil, nil],
      ['Just Arrived', '<p>Just Arrived</p>'],
      ["Just \n Arrived", "<p>Just \n<br /> Arrived</p>"]
    ].each do |values|
      argument, expected = values

      it "returns correct value for #{argument}" do
        expect(described_class.new.text_to_html(argument)).to eq(expected)
      end
    end
  end
end
