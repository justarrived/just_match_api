# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::UsersController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/users').to('api/v1/users#index', {}) }
  it { should route(:get, '/api/v1/users/1').to('api/v1/users#show', user_id: '1') }
  it { should route(:post, '/api/v1/users').to('api/v1/users#create', {}) }
  it { should route(:patch, '/api/v1/users/1').to('api/v1/users#update', user_id: '1') }
  it { should route(:delete, '/api/v1/users/1').to('api/v1/users#destroy', user_id: '1') }
  it { should route(:get, '/api/v1/users/1/matching_jobs').to('api/v1/users#matching_jobs', user_id: '1') }
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_user) }
  # === Callbacks (After) ===

  # === Callbacks (Around) ===
end
