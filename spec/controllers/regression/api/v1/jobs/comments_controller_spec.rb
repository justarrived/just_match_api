# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Jobs::JobCommentsController, regressor: true do
  # === Routes (REST) ===
  it { should route(:get, '/api/v1/jobs/1/comments').to('api/v1/jobs/job_comments#index', job_id: '1') }
  it { should route(:get, '/api/v1/jobs/1/comments/1').to('api/v1/jobs/job_comments#show', job_id: '1', id: '1') }
  it { should route(:post, '/api/v1/jobs/1/comments').to('api/v1/jobs/job_comments#create', job_id: '1') }
  it { should route(:patch, '/api/v1/jobs/1/comments/1').to('api/v1/jobs/job_comments#update', job_id: '1', id: '1') }
  it { should route(:delete, '/api/v1/jobs/1/comments/1').to('api/v1/jobs/job_comments#destroy', job_id: '1', id: '1') }
  # === Callbacks (Before) ===
  it { should use_before_filter(:set_commentable) }
  it { should use_before_filter(:set_comment) }
  # === Callbacks (After) ===

  # === Callbacks (Around) ===
end
