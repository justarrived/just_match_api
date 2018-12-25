# frozen_string_literal: true

module Admin
  class ActiveAdminFooter
    def self.to_s
      commit_sha = ENV.fetch('HEROKU_SLUG_COMMIT', '-')
      released_at = ENV.fetch('HEROKU_RELEASE_CREATED_AT', '-')

      changelog_link = nil
      unless commit_sha == '-'
        url = "https://github.com/justarrived/just_match_api/tree/#{commit_sha}"
        changelog_link = format('<a href="%s">GitHub</a>', url)
      end

      [
        "Version #{JustMatch::VERSION}",
        "Commit #{changelog_link || '-'}",
        "Released at #{released_at}"
      ].join(', ').html_safe # rubocop:disable Rails/OutputSafety
    end
  end
end
