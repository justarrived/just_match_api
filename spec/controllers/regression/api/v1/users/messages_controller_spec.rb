require 'rails_helper'

RSpec.describe Api::V1::Users::MessagesController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/users/1/messages').to('api/v1/users/messages#index', {:user_id=>"1"}) }
  it { should route(:post, '/api/v1/users/1/messages').to('api/v1/users/messages#create', {:user_id=>"1"}) } 
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_user) }
  # === Callbacks (After) ===
  
  # === Callbacks (Around) ===
  
end