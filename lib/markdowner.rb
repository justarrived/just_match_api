# frozen_string_literal: true

require 'kramdown'
require 'rinku'
require 'html_sanitizer'

module Markdowner
  def self.to_html(markdown)
    sanitized_markdown = HTMLSanitizer.sanitize(markdown)
    autolinked_markdown = Rinku.auto_link(sanitized_markdown)
    Kramdown::Document.new(autolinked_markdown, input: 'GFM').to_html
  end

  def self.to_markdown(html)
    Kramdown::Document.new(html, html_to_native: true).to_kramdown
  end
end
