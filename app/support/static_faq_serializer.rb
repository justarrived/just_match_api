# frozen_string_literal: true
class StaticFAQSerializer
  def self.serializeble_resource(locale:, language_id:, key_transform:, filter: {})
    faqs_data = []

    StaticFAQ.get(locale: locale).each_with_index do |attrs, index|
      index += 1

      next unless selected_category?(filter, attrs.fetch(:category))

      relationships = JsonApiRelationships.new
      relationships.add(relation: 'language', type: 'languages', id: language_id)

      faqs_data << JsonApiData.new(
        id: index,
        type: :faqs,
        attributes: build_attributes(attrs, language_id),
        relationships: relationships,
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

  def self.selected_category?(filter, category)
    category_filter = filter.fetch(:category, nil)
    return true if category_filter.nil?

    category_filter == category
  end
end
