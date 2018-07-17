# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'JobUsers', type: :request do
  describe 'GET /jobs/1/users' do
    context 'not authorized' do
      it 'returns not authorized status' do
        job = FactoryBot.create(:job)
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
#  id                    :integer          not null, primary key
#  user_id               :integer
#  job_id                :integer
#  accepted              :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  will_perform          :boolean          default(FALSE)
#  accepted_at           :datetime
#  performed             :boolean          default(FALSE)
#  apply_message         :text
#  language_id           :integer
#  application_withdrawn :boolean          default(FALSE)
#  shortlisted           :boolean          default(FALSE)
#  rejected              :boolean          default(FALSE)
#  http_referrer         :string(2083)
#  utm_source            :string
#  utm_medium            :string
#  utm_campaign          :string
#  utm_term              :string
#  utm_content           :string
#
# Indexes
#
#  index_job_users_on_job_id              (job_id)
#  index_job_users_on_job_id_and_user_id  (job_id,user_id) UNIQUE
#  index_job_users_on_language_id         (language_id)
#  index_job_users_on_user_id             (user_id)
#  index_job_users_on_user_id_and_job_id  (user_id,job_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (user_id => users.id)
#
