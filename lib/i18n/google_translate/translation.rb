# frozen_string_literal: true

module GoogleTranslate
  class Translation
    attr_reader :to, :from, :detected, :type

    def initialize(translation, type: :html)
      @text = translation.text
      @to = translation.to
      @origin = translation.origin
      @from = translation.from
      @detected = translation.detected?
      @type = type.to_s.downcase
    end

    def text
      return @text unless type == 'plain'

      CGI.unescapeHTML(@text).
        gsub(/<br>/, "\n")
    end

    def language
      @from
    end

    def detected?
      @detected
    end
  end
end
