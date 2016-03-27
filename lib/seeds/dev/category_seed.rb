# frozen_string_literal: true
require 'seeds/dev/base_seed'

module Dev
  class CategorySeed < BaseSeed
    def self.call
      max_categories = max_count_opt('MAX_CATEGORIES', 10)

      log '[db:seed] Category'
      max_categories.times do |n|
        Category.create!(name: "#{Faker::Company.profession} #{n}")
      end
    end
  end
end
