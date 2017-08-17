# frozen_string_literal: true

module Admin
  class ActiveAdminFooter < ActiveAdmin::Component
    def build(_namespace)
      super(id: 'footer')
      commit_sha = ENV.fetch('HEROKU_SLUG_COMMIT', '-')
      released_at = ENV.fetch('HEROKU_RELEASE_CREATED_AT', '-')

      changelog_link = nil
      unless commit_sha == '-'
        url = "https://github.com/justarrived/just_match_api/tree/#{commit_sha}"
        changelog_link = link_to('GitHub', url)
      end

      para safe_join(
        [
          "Version: #{JustMatch::VERSION}",
          safe_join(['Commit: ', changelog_link || '-']),
          "Released at: #{released_at}"
        ],
        ', '
      )
    end
  end
end
