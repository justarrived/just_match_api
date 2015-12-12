require 'rails_helper'

RSpec.describe Api::V1::SkillsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/skills').to('api/v1/skills#index', {}) }
  it { should route(:get, '/api/v1/skills/1').to('api/v1/skills#show', {:id=>"1"}) }
  it { should route(:post, '/api/v1/skills').to('api/v1/skills#create', {}) } 
  it { should route(:patch, '/api/v1/skills/1').to('api/v1/skills#update', {:id=>"1"}) } 
  it { should route(:delete, '/api/v1/skills/1').to('api/v1/skills#destroy', {:id=>"1"}) } 
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_skill) }
  # === Callbacks (After) ===
  
  # === Callbacks (Around) ===
  
end