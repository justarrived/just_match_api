# frozen_string_literal: true
module Index
  class ChatsIndex < BaseIndex
    def chats(scope = Chat)
      @chats ||= begin
        records = scope.includes(%i(users messages))
        prepare_records(records)
      end
    end
  end
end
