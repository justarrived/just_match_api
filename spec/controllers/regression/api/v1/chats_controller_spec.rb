# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Chats::ChatsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/chats').to('api/v1/chats#index', {}) }
  it { should route(:get, '/api/v1/chats/1').to('api/v1/chats#show', id: '1') }
  it { should route(:post, '/api/v1/chats').to('api/v1/chats#create', {}) }
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_chat) }
  # === Callbacks (After) ===

  # === Callbacks (Around) ===
end
