# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'JobUsers', type: :request do
  describe 'GET /jobs/1/users' do
    context 'not authorized' do
      it 'returns not authorized status' do
        job = FactoryGirl.create(:job)
        get api_v1_job_users_path(job_id: job.to_param)
        expect(response).to have_http_status(401)
      end
    end
  end
end

# == Schema Information
#
# Table name: job_users
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  job_id             :integer
#  accepted           :boolean          default(FALSE)
#  rate               :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  will_perform       :boolean          default(FALSE)
#  accepted_at        :datetime
#  performed          :boolean          default(FALSE)
#  performed_accepted :boolean          default(FALSE)
#
# Indexes
#
#  index_job_users_on_job_id              (job_id)
#  index_job_users_on_job_id_and_user_id  (job_id,user_id) UNIQUE
#  index_job_users_on_user_id             (user_id)
#  index_job_users_on_user_id_and_job_id  (user_id,job_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_548d2d3ba9  (job_id => jobs.id)
#  fk_rails_815844930e  (user_id => users.id)
#
