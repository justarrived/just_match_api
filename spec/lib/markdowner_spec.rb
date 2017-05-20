# frozen_string_literal: true

require 'spec_helper'
require 'markdowner'

RSpec.describe Markdowner do
  describe '::to_html' do
    it 'converts markdown to HTML' do
      markdown = '# Testing'
      expect(Markdowner.to_html(markdown)).to eq("<h1 id=\"testing\">Testing</h1>\n")
    end

    it 'converts markdown to HTML and autolinks' do
      markdown = 'www.example.com'
      expected = "<p><a href=\"http://www.example.com\">www.example.com</a></p>\n"
      expect(Markdowner.to_html(markdown)).to eq(expected)
    end
  end

  describe '::to_markdown' do
    it 'converts HTML to markdown' do
      markdown = '<h1>Testing</h1>'
      expect(Markdowner.to_markdown(markdown)).to eq("# Testing\n\n")
    end
  end
end
