# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Jobs::UsersController do
  describe 'GET #missing_traits' do
    context 'with valid params' do
      let(:admin_user) { FactoryGirl.create(:admin_user, city: nil) }
      let(:job) { FactoryGirl.create(:job_with_traits) }

      before(:each) do
        allow_any_instance_of(User).to receive(:persisted?).and_return(true)
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
      end

      it 'returns the missing traits' do
        get :missing_traits, params: { job_id: job.id, user_id: admin_user.id }

        skill_ids = job.skills.map(&:id)
        language_ids = job.languages.map(&:id)

        expect(response.body).to be_jsonapi_attribute('city', {})
        expect(response.body).to be_jsonapi_attribute('skill-ids', 'ids' => skill_ids)
        expect(response.body).to be_jsonapi_attribute('language-ids', 'ids' => language_ids) # rubocop:disable Metrics/LineLength
      end
    end
  end

  describe 'GET #job_user' do
    context 'with valid params' do
      let(:admin_user) { FactoryGirl.create(:admin_user) }
      let(:job) { FactoryGirl.create(:job) }

      before(:each) do
        allow_any_instance_of(User).to receive(:persisted?).and_return(true)
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
      end

      it 'returns has applied false under meta key if user has not applied' do
        get :job_user, params: { job_id: job.id, user_id: admin_user.id }
        expect(JSON.parse(response.body)['meta']).to eq('has_applied' => false)
      end

      it 'returns job user & has applied true under meta key if user has not applied' do
        FactoryGirl.create(:job_user, user: admin_user, job: job)
        get :job_user, params: { job_id: job.id, user_id: admin_user.id }

        expect(JSON.parse(response.body)['meta']).to eq('has-applied' => true)
        expect(response.body).to be_jsonapi_response_for('job-users', {})
      end
    end
  end
end
