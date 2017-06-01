# frozen_string_literal: true

require 'yaml'

class ReadStaticFAQ
  FAQ_LOCALES = %w(en sv ar).freeze

  def self.call
    faqs = {}

    FAQ_LOCALES.each do |locale|
      hash = YAML.load_file(locale_path(locale))

      flatten_hash(hash[locale]).each_slice(4) do |question_answer_pair|
        question_key, question, _answer_key, answer = question_answer_pair

        faqs[locale] ||= []
        faqs[locale] << {
          category: category(question_key),
          question: question,
          answer: answer
        }
      end
    end

    faqs
  end

  def self.category(question_key)
    key = question_key.split('.')
    key.shift # ignore the first key 'faq'
    key.shift # the second key is the type company/newcomer etc
  end

  def self.locale_path(locale)
    "config/locales/faq/faq.#{locale}.yml"
  end

  def self.flatten_hash(hash, parent = [])
    hash.flat_map do |key, value|
      case value
      when Hash then flatten_hash(value, parent + [key])
      else
        keys = (parent + [key])
        [keys.join('.'), value]
      end
    end
  end
end
