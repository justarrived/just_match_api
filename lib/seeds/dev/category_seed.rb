# frozen_string_literal: true
require 'seeds/dev/base_seed'

module Dev
  class CategorySeed < BaseSeed
    def self.call
      max_categories = max_count_opt('MAX_CATEGORIES', 10)
      before_count = Category.count

      log 'Creating Categories'
      max_categories.times do |n|
        Category.create!(name: "#{Faker::Company.profession} #{n}")
      end
      log "Created #{Category.count - before_count} Categories"
    end
  end
end
