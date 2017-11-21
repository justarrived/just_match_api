# frozen_string_literal: true

module Queries
  class MissingUserTraits
    attr_reader :user

    def initialize(user:)
      @user = user
      @missing_cv = nil
    end

    def attributes(attributes:)
      user_attributes = user.all_attributes
      attributes.select { |name| user_attributes.fetch(name.to_s).blank? }
    end

    def skills(skills:)
      skills - user.skills
    end

    def languages(languages:)
      languages - user.languages
    end

    def occupations(occupations:)
      occupations - user.occupations
    end

    def cv?
      return @missing_cv unless @missing_cv.nil?

      @missing_cv = user.user_documents.cv.last.nil?
    end
  end
end
