# frozen_string_literal: true
require 'seeds/base_seed'

module Dev
  class InterestSeed < BaseSeed
    def self.call
      max_interests = max_count_opt('MAX_INTERESTS', 30)

      language = Language.find_by!(lang_code: 'en')

      log_seed(Interest) do
        max_interests.times do
          name = Faker::Name.unique.title
          interest = Interest.create!(
            name: name,
            language: language
          )
          interest.set_translation(name: name)
        end
      end
    end
  end
end
