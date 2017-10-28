# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Jobs::JobUsersController, type: :controller do
  let(:user) do
    FactoryGirl.create(:user_with_tokens, company: FactoryGirl.create(:company))
  end
  let(:owner) { User.find_by_auth_token(valid_session[:token]) }

  let(:valid_attributes) do
    { auth_token: user.auth_token }
  end

  let(:invalid_attributes) do
    {}
  end

  describe 'GET #index' do
    it 'assigns all user users as @users' do
      job = FactoryGirl.create(:job_with_users, users_count: 1, owner: user)
      job_user = job.job_users.first
      get :index, params: { auth_token: user.auth_token, job_id: job.to_param }
      expect(assigns(:job_users)).to eq([job_user])
    end

    context 'not authorized' do
      it 'returns not authorized status' do
        job = FactoryGirl.create(:job_with_users, users_count: 1)
        get :index, params: { auth_token: user.auth_token, job_id: job.to_param }
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'GET #show' do
    it 'assigns @user, @job and @job_user' do
      job = FactoryGirl.create(:job_with_users, users_count: 1, owner: user)
      user = job.users.first
      user.create_auth_token
      job_user = job.job_users.first
      params = {
        auth_token: user.auth_token,
        job_id: job.to_param,
        job_user_id: job_user.to_param
      }
      get :show, params: params
      expect(assigns(:user)).to eq(user)
      expect(assigns(:job)).to eq(job)
      expect(assigns(:job_user)).to eq(job_user)
    end

    context 'not authorized' do
      it 'returns unauthorized status' do
        job = FactoryGirl.create(:job_with_users, users_count: 1)
        job_user = job.job_users.first
        params = {
          auth_token: user.auth_token,
          job_id: job.to_param,
          job_user_id: job_user.to_param
        }
        get :show, params: params
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new JobUser' do
        user = FactoryGirl.create(:user_with_tokens)
        user1 = FactoryGirl.create(:company_user)
        job = FactoryGirl.create(:job, owner: user1)
        params = {
          auth_token: user.auth_token,
          job_id: job.to_param,
          user: { id: user.to_param }
        }
        expect do
          post :create, params: params
        end.to change(JobUser, :count).by(1)
      end

      it 'enqueues a data update reminder' do
        user = FactoryGirl.create(:user_with_tokens)
        user1 = FactoryGirl.create(:company_user)
        job = FactoryGirl.create(:job, owner: user1)
        params = {
          auth_token: user.auth_token,
          job_id: job.to_param,
          user: { id: user.to_param }
        }
        expect do
          post :create, params: params
        end.to have_enqueued_job(UpdateApplicantDataReminderJob)
      end

      it 'forbidden if user tries to apply as someone else' do
        user = FactoryGirl.create(:user)
        other_user = FactoryGirl.create(:user_with_tokens)
        user1 = FactoryGirl.create(:company_user)
        job = FactoryGirl.create(:job, owner: user1)
        params = {
          auth_token: other_user.auth_token,
          job_id: job.to_param,
          user: { id: user.to_param },
          data: {
            attributes: { user_id: 730_007 }
          }
        }
        post :create, params: params
        expect(response.status).to eq(403)
        parsed_body = JSON.parse(response.body)
        error = parsed_body['errors'].first
        expect(error['status']).to eq(403)
        expect(error['detail']).to eq(I18n.t('errors.job_user.forbidden_applicant_user'))
      end

      context 'with apply message' do
        let(:language) { FactoryGirl.create(:language) }
        let(:apply_message) { 'Something something, darkside..' }

        it 'creates a apply message' do
          user = FactoryGirl.create(:user_with_tokens)
          user1 = FactoryGirl.create(:company_user)
          job = FactoryGirl.create(:job, owner: user1)
          params = {
            auth_token: user.auth_token,
            job_id: job.to_param,
            user: { id: user.to_param },
            data: {
              attributes: {
                apply_message: apply_message,
                language_id: language.id
              }
            }
          }
          post :create, params: params
          job_user = assigns(:job_user)
          job_user.reload
          expect(job_user).to be_a(JobUser)
          expect(job_user).to be_persisted
          expect(job_user.translations.length).to eq(1)
          expect(job_user.original_apply_message).to eq(apply_message)
        end
      end

      context 'with referrer and utm data' do
        let(:language) { FactoryGirl.create(:language) }

        it 'creates a job user with referrer & UTM data' do
          user = FactoryGirl.create(:user_with_tokens)
          user1 = FactoryGirl.create(:company_user)
          job = FactoryGirl.create(:job, owner: user1)
          params = {
            auth_token: user.auth_token,
            job_id: job.to_param,
            user: { id: user.to_param },
            data: {
              attributes: {
                http_referrer: 'http_referrer',
                utm_term: 'utm_term',
                utm_source: 'utm_source',
                utm_medium: 'utm_medium',
                utm_content: 'utm_content',
                utm_campaign: 'utm_campaign'
              }
            }
          }
          request_http_referrer = 'http://example.com'
          @request.env['HTTP_REFERER'] = request_http_referrer

          post :create, params: params
          job_user = assigns(:job_user)
          job_user.reload
          expect(job_user).to be_a(JobUser)
          expect(job_user.http_referrer).to eq('http_referrer')
          # Make sure that the param overrides the HTTP header
          expect(job_user.http_referrer).not_to eq(request_http_referrer)
          expect(job_user.utm_term).to eq('utm_term')
          expect(job_user.utm_source).to eq('utm_source')
          expect(job_user.utm_medium).to eq('utm_medium')
          expect(job_user.utm_content).to eq('utm_content')
          expect(job_user.utm_campaign).to eq('utm_campaign')
        end

        it 'creates a job user with referrer from request' do
          user = FactoryGirl.create(:user_with_tokens)
          user1 = FactoryGirl.create(:company_user)
          job = FactoryGirl.create(:job, owner: user1)
          params = {
            auth_token: user.auth_token,
            job_id: job.to_param,
            user: { id: user.to_param },
            data: {
              attributes: {
                utm_source: 'utm_source'
              }
            }
          }
          http_referrer = 'http://example.com'
          @request.env['HTTP_REFERER'] = http_referrer

          post :create, params: params
          job_user = assigns(:job_user)
          job_user.reload
          expect(job_user).to be_a(JobUser)
          expect(job_user.http_referrer).to eq(http_referrer)
          expect(job_user.utm_source).to eq('utm_source')
        end
      end

      it 'returns created status' do
        user = FactoryGirl.create(:user_with_tokens)
        user1 = FactoryGirl.create(:company_user)
        job = FactoryGirl.create(:job, owner: user1)
        params = {
          auth_token: user.auth_token,
          job_id: job.to_param,
          user: { id: user.to_param }
        }
        post :create, params: params
        expect(response.status).to eq(201)
      end

      it 'notifies owner when a a new JobUser is created' do
        user = FactoryGirl.create(:user_with_tokens)
        user1 = FactoryGirl.create(:company_user)
        job = FactoryGirl.create(:job, owner: user1)
        params = {
          auth_token: user.auth_token,
          job_id: job.to_param,
          user: { id: user.to_param }
        }
        allow(NewApplicantNotifier).to receive(:call)
        post :create, params: params
        expect(NewApplicantNotifier).to have_received(:call)
      end
    end

    context 'with invalid params' do
      it 'returns unprocessable entity status' do
        job = FactoryGirl.create(:job, owner: user)
        post :create, params: {
          auth_token: user.auth_token,
          job_id: job.to_param,
          user: {}
        }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'not allowed' do
      it 'does not destroy the requested job_user' do
        job = FactoryGirl.create(:job_with_users)
        job_user = job.job_users.first
        params = { job_id: job.to_param, job_user_id: job_user.to_param }
        expect do
          delete :destroy, params: params
        end.to change(JobUser, :count).by(0)
      end

      it 'returns not allowed status' do
        job = FactoryGirl.create(:job_with_users)
        job_user = job.job_users.first
        random_user = FactoryGirl.create(:user_with_tokens)
        params = {
          auth_token: random_user.auth_token,
          job_id: job.to_param,
          job_user_id: job_user.to_param
        }
        delete :destroy, params: params
        expect(response.status).to eq(403)
      end
    end

    context 'allowed' do
      it 'can *not* be destroyed if JobUser#will_perform is true' do
        job = FactoryGirl.create(:job_with_users, users_count: 1)
        user = job.users.first.tap(&:create_auth_token)
        job_user = job.job_users.first
        job.job_users.first.update_attributes(accepted: true, will_perform: true)

        params = {
          auth_token: user.auth_token,
          job_id: job.to_param,
          job_user_id: job_user.to_param
        }
        delete :destroy, params: params
        err_msg = I18n.t('errors.job_user.will_perform_true_on_delete')
        expect(response.status).to eq(422)
        parsed_body = JSON.parse(response.body)
        error = parsed_body['errors'].first
        will_perform = error['detail']
        status = error['status']
        expect(status).to eq(422)
        expect(will_perform).to eq(err_msg)
      end

      it 'sends a notification to Job#owner if accepted applicant withdraws' do
        job = FactoryGirl.create(:job_with_users, users_count: 1)
        user = job.users.first.tap(&:create_auth_token)
        job_user = job.job_users.first
        job.job_users.first.update_attributes(accepted: true)

        params = {
          auth_token: user.auth_token,
          job_id: job.to_param,
          job_user_id: job_user.to_param
        }
        allow(AcceptedApplicantWithdrawnNotifier).to receive(:call)
        delete :destroy, params: params
        expect(AcceptedApplicantWithdrawnNotifier).to have_received(:call)
      end

      it 'returns no content status' do
        job = FactoryGirl.create(:job_with_users, users_count: 1)
        user = job.users.first.tap(&:create_auth_token)
        job_user = job.job_users.first

        params = {
          auth_token: user.auth_token,
          job_id: job.to_param,
          job_user_id: job_user.to_param
        }
        delete :destroy, params: params
        expect(response.status).to eq(204)
      end
    end
  end
end
