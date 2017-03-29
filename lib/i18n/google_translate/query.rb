# frozen_string_literal: true
module GoogleTranslate
  class Query
    attr_reader :type

    def initialize(text, type:)
      @text = text
      @type = type
    end

    def to_s
      return @text unless type == :plain
      return @text if @text.nil?

      # NOTE: Google treats the text as HTML and therefore doesn't preserve newlines
      replacement = '<br>'
      @text.gsub(/\r\n/, replacement).gsub(/\n/, replacement)
    end
  end
end
