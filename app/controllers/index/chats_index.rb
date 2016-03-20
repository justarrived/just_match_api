# frozen_string_literal: true
module Index
  class ChatsIndex < BaseIndex
    def chats
      @chats ||= begin
        records = Chat.includes(%i(users messages))
        prepare_records(records)
      end
    end
  end
end
