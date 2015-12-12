require 'rails_helper'

RSpec.describe Api::V1::JobsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/jobs').to('api/v1/jobs#index', {}) }
  it { should route(:get, '/api/v1/jobs/1').to('api/v1/jobs#show', {:job_id=>"1"}) }
  it { should route(:post, '/api/v1/jobs').to('api/v1/jobs#create', {}) }
  it { should route(:patch, '/api/v1/jobs/1').to('api/v1/jobs#update', {:job_id=>"1"}) }
  it { should route(:get, '/api/v1/jobs/1/matching_users').to('api/v1/jobs#matching_users', {:job_id=>"1"}) }
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_job) }
  # === Callbacks (After) ===

  # === Callbacks (Around) ===

end
