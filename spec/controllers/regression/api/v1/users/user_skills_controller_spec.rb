# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::UserSkillsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/users/1/skills').to('api/v1/users/user_skills#index', user_id: '1') }
  it { should route(:get, '/api/v1/users/1/skills/1').to('api/v1/users/user_skills#show', user_id: '1', id: '1') }
  it { should route(:post, '/api/v1/users/1/skills').to('api/v1/users/user_skills#create', user_id: '1') }
  it { should route(:delete, '/api/v1/users/1/skills/1').to('api/v1/users/user_skills#destroy', user_id: '1', id: '1') }
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_user) }
  it { should use_before_filter(:set_skill) }
  # === Callbacks (After) ===

  # === Callbacks (Around) ===
end
