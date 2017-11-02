# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Jobs::UsersController do
  describe 'GET #missing_traits' do
    context 'with valid params' do
      let(:admin_user) { FactoryBot.create(:admin_user, city: nil) }
      let(:job) { FactoryBot.create(:job_with_traits) }

      before(:each) do
        allow_any_instance_of(User).to receive(:persisted?).and_return(true)
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
      end

      it 'returns the missing traits' do
        get :missing_traits, params: { job_id: job.id, user_id: admin_user.id }

        skill_hash = {
          'ids' => job.skills.map(&:id),
          'hint' => I18n.t('user.missing_job_skills_trait')
        }

        language_hash = {
          'ids' => job.languages.map(&:id),
          'hint' => I18n.t('user.missing_job_languages_trait')
        }

        expect(response.body).to be_jsonapi_attribute('city', {})
        expect(response.body).to be_jsonapi_attribute('skill_ids', skill_hash)
        expect(response.body).to be_jsonapi_attribute('language_ids', language_hash)
      end
    end
  end

  describe 'GET #job_user' do
    context 'with valid params' do
      let(:admin_user) { FactoryBot.create(:admin_user) }
      let(:job) { FactoryBot.create(:job) }

      before(:each) do
        allow_any_instance_of(User).to receive(:persisted?).and_return(true)
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
      end

      it 'returns has applied false under meta key if user has not applied' do
        get :job_user, params: { job_id: job.id, user_id: admin_user.id }
        expect(JSON.parse(response.body)['meta']).to eq('has_applied' => false)
      end

      it 'returns job user & has applied true under meta key if user has not applied' do
        FactoryBot.create(:job_user, user: admin_user, job: job)
        get :job_user, params: { job_id: job.id, user_id: admin_user.id }

        expect(JSON.parse(response.body)['meta']).to eq('has_applied' => true)
        expect(response.body).to be_jsonapi_response_for('job_users', {})
      end
    end
  end
end
