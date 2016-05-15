# frozen_string_literal: true
module Index
  class MessagesIndex < BaseIndex
    def messages(scope = Message)
      @messages ||= begin
        include_scopes = [:language]
        include_scopes << user_include_scopes(user_key: :author)

        prepare_records(scope.includes(*include_scopes))
      end
    end
  end
end
