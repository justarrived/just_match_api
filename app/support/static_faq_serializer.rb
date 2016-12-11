# frozen_string_literal: true
class StaticFAQSerializer
  def self.serializeble_resource(locale:, key_transform:, filter: {})
    faqs_data = []
    language_id = Language.find_by(lang_code: locale).id

    StaticFAQ.get(locale: locale).each_with_index do |attrs, index|
      index += 1

      faqs_data << JsonApiData.new(
        id: index,
        type: :faqs,
        attributes: build_attributes(attrs, language_id),
        key_transform: key_transform
      )
    end

    JsonApiDatum.new(faqs_data)
  end

  def self.build_attributes(attrs, language_id)
    question = attrs.fetch(:question)
    answer = attrs.fetch(:answer)
    category = attrs.fetch(:category)

    {
      question: question,
      answer: answer,
      category: category,
      language_id: language_id,
      translated_text: {
        question: question,
        answer: answer,
        language_id: language_id
      }
    }
  end
end
