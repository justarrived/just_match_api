# frozen_string_literal: true
require 'seeds/base_seed'

module Dev
  class FaqSeed < BaseSeed
    def self.call(languages:)
      max_faqs = max_count_opt('MAX_FAQS', 15)

      log_seed(Faq) do
        max_faqs.times do
          Faq.create!(
            answer: Faker::Company.catch_phrase,
            question: Faker::Company.bs,
            language: languages.sample
          )
        end
      end
    end
  end
end
