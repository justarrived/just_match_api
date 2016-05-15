# frozen_string_literal: true
module Index
  class CommentsIndex < BaseIndex
    def comments(scope = Comment)
      @comments ||= begin
        includes_scopes = [:language]
        includes_scopes << user_include_scopes(user_key: :owner)

        prepare_records(scope.includes(*includes_scopes))
      end
    end
  end
end
