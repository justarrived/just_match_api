require 'rails_helper'

RSpec.describe Api::V1::Chats::MessagesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/chats/1/messages').to('api/v1/chats/messages#index', id: '1') }
  it { should route(:post, '/api/v1/chats/1/messages').to('api/v1/chats/messages#create', id: '1') }
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_chat) }
  # === Callbacks (After) ===

  # === Callbacks (Around) ===
end
