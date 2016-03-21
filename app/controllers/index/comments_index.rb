# frozen_string_literal: true
module Index
  class CommentsIndex < BaseIndex
    ALLOWED_INCLUDES = %w(language owner).freeze

    def comments(scope = Comment)
      @comments ||= begin
        includes_scopes = [:language]
        includes_scopes << user_include_scopes(:owner)

        prepare_records(scope.includes(*includes_scopes))
      end
    end
  end
end
