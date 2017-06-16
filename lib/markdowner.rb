# frozen_string_literal: true

require 'kramdown'
require 'rinku'
require 'nokogiri'
require 'html_sanitizer'

module Markdowner
  MARKDOWN_LINE_WIDTH = 250

  def self.to_html(markdown)
    sanitized_markdown = HTMLSanitizer.sanitize(markdown)
    autolinked_markdown = Rinku.auto_link(sanitized_markdown)
    Kramdown::Document.new(autolinked_markdown, input: 'GFM').to_html
  end

  def self.to_markdown(html)
    Kramdown::Document.new(
      html,
      html_to_native: true,
      line_width: MARKDOWN_LINE_WIDTH
    ).to_kramdown
  end

  def self.html_to_text(html)
    document = Nokogiri::HTML.parse(html)
    well_formatted_html = document.to_html # Helps preserving new lines etc.
    Nokogiri::HTML.parse(well_formatted_html).text.strip
  end
end
