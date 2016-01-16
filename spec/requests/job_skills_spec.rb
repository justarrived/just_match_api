# == Schema Information
#
# Table name: job_skills
#
#  id         :integer          not null, primary key
#  job_id     :integer
#  skill_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_job_skills_on_job_id    (job_id)
#  index_job_skills_on_skill_id  (skill_id)
#
# Foreign Keys
#
#  fk_rails_514cd69e1b  (skill_id => skills.id)
#  fk_rails_94b0ff3621  (job_id => jobs.id)
#

require 'rails_helper'

RSpec.describe 'JobSkills', type: :request do
  describe 'GET /jobs/1/skills' do
    it 'works!' do
      job = FactoryGirl.create(:job)
      get api_v1_job_skills_path(job_id: job.to_param)
      expect(response).to have_http_status(200)
    end
  end
end
