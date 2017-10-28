# frozen_string_literal: true

module Queries
  class MissingUserTraits
    def self.attributes(user:, attributes:)
      user_attributes = user.all_attributes
      attributes.select { |name| user_attributes.fetch(name.to_s).blank? }
    end

    def self.skills(user:, skills:)
      skills - user.skills
    end

    def self.languages(user:, languages:)
      languages - user.languages
    end

    def self.cv?(user:)
      user.user_documents.cv.last.nil?
    end
  end
end
