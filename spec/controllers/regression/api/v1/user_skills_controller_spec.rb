require 'rails_helper'

RSpec.describe Api::V1::UserSkillsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/user_skills').to('api/v1/user_skills#index', {}) }
  it { should route(:get, '/api/v1/user_skills/1').to('api/v1/user_skills#show', {:id=>"1"}) }
  it { should route(:post, '/api/v1/user_skills').to('api/v1/user_skills#create', {}) } 
  it { should route(:patch, '/api/v1/user_skills/1').to('api/v1/user_skills#update', {:id=>"1"}) } 
  it { should route(:delete, '/api/v1/user_skills/1').to('api/v1/user_skills#destroy', {:id=>"1"}) } 
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_user_skill) }
  # === Callbacks (After) ===
  
  # === Callbacks (Around) ===
  
end