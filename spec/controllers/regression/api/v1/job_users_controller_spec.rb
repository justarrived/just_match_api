require 'rails_helper'

RSpec.describe Api::V1::JobUsersController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/job_users').to('api/v1/job_users#index', {}) }
  it { should route(:get, '/api/v1/job_users/1').to('api/v1/job_users#show', {:id=>"1"}) }
  it { should route(:post, '/api/v1/job_users').to('api/v1/job_users#create', {}) }
  it { should route(:patch, '/api/v1/job_users/1').to('api/v1/job_users#update', {:id=>"1"}) }
  it { should route(:delete, '/api/v1/job_users/1').to('api/v1/job_users#destroy', {:id=>"1"}) }
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_job_user) }
  # === Callbacks (After) ===

  # === Callbacks (Around) ===

end
