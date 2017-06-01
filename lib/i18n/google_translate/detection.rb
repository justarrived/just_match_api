# frozen_string_literal: true

module GoogleTranslate
  class Detection
    attr_reader :text, :language, :confidence

    def initialize(detection)
      @text = detection.text
      @language = detection.language
      @confidence = detection.confidence
    end
  end
end
