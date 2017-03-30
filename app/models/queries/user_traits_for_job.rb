# frozen_string_literal: true

module Queries
  class UserTraitsForJob
    def self.missing_user_attributes(user:)
      user_attributes = user.attributes
      %w(ssn street zip city phone).select { |name| user_attributes[name].blank? }
    end

    def self.missing_skills(job:, user:)
      job.skills - user.skills
    end

    def self.missing_languages(job:, user:)
      job.languages - user.languages
    end
  end
end
