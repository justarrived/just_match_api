require 'rails_helper'

RSpec.describe Api::V1::Users::CommentsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/users/1/comments').to('api/v1/users/comments#index', {:user_id=>"1"}) }
  it { should route(:get, '/api/v1/users/1/comments/1').to('api/v1/users/comments#show', {:user_id=>"1", :id=>"1"}) }
  it { should route(:post, '/api/v1/users/1/comments').to('api/v1/users/comments#create', {:user_id=>"1"}) } 
  it { should route(:patch, '/api/v1/users/1/comments/1').to('api/v1/users/comments#update', {:user_id=>"1", :id=>"1"}) } 
  it { should route(:delete, '/api/v1/users/1/comments/1').to('api/v1/users/comments#destroy', {:user_id=>"1", :id=>"1"}) } 
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_commentable) }
  it { should use_before_filter(:set_comment) }
  # === Callbacks (After) ===
  
  # === Callbacks (Around) ===
  
end