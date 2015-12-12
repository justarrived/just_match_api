require 'rails_helper'

RSpec.describe Api::V1::JobSkillsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/job_skills').to('api/v1/job_skills#index', {}) }
  it { should route(:get, '/api/v1/job_skills/1').to('api/v1/job_skills#show', {:id=>"1"}) }
  it { should route(:post, '/api/v1/job_skills').to('api/v1/job_skills#create', {}) }
  it { should route(:patch, '/api/v1/job_skills/1').to('api/v1/job_skills#update', {:id=>"1"}) }
  it { should route(:delete, '/api/v1/job_skills/1').to('api/v1/job_skills#destroy', {:id=>"1"}) }
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_job_skill) }
  # === Callbacks (After) ===

  # === Callbacks (Around) ===

end
