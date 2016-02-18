# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Jobs::JobSkillsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/jobs/1/skills').to('api/v1/jobs/job_skills#index', job_id: '1') }
  it { should route(:get, '/api/v1/jobs/1/skills/1').to('api/v1/jobs/job_skills#show', job_id: '1', id: '1') }
  it { should route(:post, '/api/v1/jobs/1/skills').to('api/v1/jobs/job_skills#create', job_id: '1') }
  it { should route(:delete, '/api/v1/jobs/1/skills/1').to('api/v1/jobs/job_skills#destroy', job_id: '1', id: '1') }
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_job) }
  it { should use_before_filter(:set_skill) }
  # === Callbacks (After) ===

  # === Callbacks (Around) ===
end
