# frozen_string_literal: true

require 'spec_helper'
require 'html_sanitizer'

RSpec.describe HTMLSanitizer do
  describe '::sanitize' do
    it 'escapes all script tags' do
      html = '<script>test</script>'
      expect(HTMLSanitizer.sanitize(html)).to eq('&lt;script&gt;test&lt;/script&gt;')
    end
  end
end
