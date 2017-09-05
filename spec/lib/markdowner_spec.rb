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

    it 'converts markdown, with links, to HTML and autolinks' do
      markdown = '[example.com](http://example.com) www.example.com'
      expected = "<p><a href=\"http://example.com\">example.com</a> <a href=\"http://www.example.com\">www.example.com</a></p>\n" # rubocop:disable Metrics/LineLength
      expect(Markdowner.to_html(markdown)).to eq(expected)
    end
  end

  describe '::to_markdown' do
    it 'converts HTML to markdown' do
      markdown = '<h1>Testing</h1>'
      expect(Markdowner.to_markdown(markdown)).to eq("# Testing\n\n")
    end
  end

  describe '::html_to_text' do
    it 'converts HTML to plain text' do
      html = '<div><p>Testing</p><h1>Heading</h1></div>'
      expect(Markdowner.html_to_text(html)).to eq("Testing\nHeading")
    end
  end
end
