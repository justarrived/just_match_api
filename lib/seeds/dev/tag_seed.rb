# frozen_string_literal: true
require 'seeds/base_seed'

module Dev
  class TagSeed < BaseSeed
    def self.call

      log_seed(Tag) do
        %w(content happy grumpy awesome nice random smug).each do |name|
          tag = Tag.find_or_initialize_by(name: name)
          tag.color ||= random_color
          tag.save!
        end
      end
    end

    def self.random_color
      '#' + '%06x' % (rand * 0xffffff)
    end
  end
end
