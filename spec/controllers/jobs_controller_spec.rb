# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::JobsController, type: :controller do
  let(:company) { FactoryBot.create(:company) }
  let(:owner) { FactoryBot.create(:user, company: company).tap(&:create_auth_token) }
  let(:logged_in_user) { FactoryBot.create(:user_with_tokens, company: company) }
  let(:valid_attributes) do
    {
      auth_token: logged_in_user.auth_token,
      data: {
        attributes: {
          hours: 2,
          name: 'Some job name',
          short_description: 'Short description',
          description: 'Some job description',
          language_id: FactoryBot.create(:language).id,
          hourly_pay_id: FactoryBot.create(:hourly_pay, gross_salary: 100).id,
          category_id: FactoryBot.create(:category).id,
          owner_user_id: owner.id,
          street: 'Stora Nygatan 36',
          city: 'Malmö',
          zip: '211 37',
          job_date: 1.day.from_now,
          job_end_date: 2.days.from_now
        }
      }
    }
  end

  let(:invalid_attributes) do
    {
      auth_token: logged_in_user.auth_token,
      data: {
        attributes: { hours: nil }
      }
    }
  end

  describe 'GET #index' do
    it 'assigns all jobs as @jobs' do
      job = FactoryBot.create(:published_job)
      process :index, method: :get
      expect(assigns(:jobs)).to eq([job])
    end

    it 'returns sorted results' do
      FactoryBot.create(:published_job, hours: 7)
      FactoryBot.create(:published_job, hours: 10)
      FactoryBot.create(:published_job, hours: 5)

      get :index, params: { sort: '-hours' }
      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)

      job_hours_count = parsed_body['data'].map do |job|
        job['attributes']['hours'].to_i
      end
      expect(job_hours_count).to eq([10, 7, 5])
    end

    it 'allows expired user token' do
      user = FactoryBot.create(:user)
      token = FactoryBot.create(:expired_token, user: user)
      value = token.token
      request.headers['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(value) # rubocop:disable Metrics/LineLength

      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested job as @job' do
      job = FactoryBot.create(:published_job)
      get :show, params: { job_id: job.to_param }
      expect(assigns(:job)).to eq(job)
    end

    it 'allows expired user token' do
      user = FactoryBot.create(:user)
      token = FactoryBot.create(:expired_token, user: user)
      value = token.token
      request.headers['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(value) # rubocop:disable Metrics/LineLength

      job = FactoryBot.create(:published_job)
      get :show, params: { job_id: job.to_param }
      expect(response.status).to eq(200)
    end

    context 'job with preview key' do
      it 'assigns the requested job as @job if the correct preview key is provided' do
        key = 'nososecret'
        job = FactoryBot.create(:published_job, preview_key: key)
        get :show, params: { job_id: job.to_param, preview_key: key }
        expect(assigns(:job)).to eq(job)
      end

      it 'returns 404 if no preview key is provided' do
        job = FactoryBot.create(:job, preview_key: 'nososecret')
        get :show, params: { job_id: job.to_param }
        expect(response.status).to eq(404)
      end

      it 'returns 404 if the incorrect preview key is provided' do
        job = FactoryBot.create(:published_job, preview_key: 'nososecret')
        get :show, params: { job_id: job.to_param, preview_key: 'wrongpreviewkey' }
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'POST #create' do
    let(:logged_in_user) { owner }

    context 'with valid params' do
      it 'creates a new Job' do
        expect do
          post :create, params: valid_attributes
        end.to change(Job, :count).by(1)
      end

      it 'works' do
        post :create, params: valid_attributes
        job = assigns(:job)

        expect(job.translations.length).to eq(1)
        expect(job).to be_a(Job)
        expect(job).to be_persisted
        expect(job.customer_hourly_price).to eq(140)
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved job as @job' do
        post :create, params: invalid_attributes
        expect(assigns(:job)).to be_a_new(Job)
      end

      it 'returns 422 status' do
        post :create, params: invalid_attributes
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_hours) { 8 }
      let(:new_attributes) do
        {
          auth_token: owner.auth_token,
          data: {
            attributes: { hours: new_hours }
          }
        }
      end

      context 'owner user' do
        it 'updates the requested job' do
          job = FactoryBot.create(:job, owner: owner)
          params = { job_id: job.to_param }.merge(new_attributes)
          put :update, params: params
          job.reload
          expect(job.hours).to eq(new_hours)
        end

        it 'assigns the requested user as @job' do
          job = FactoryBot.create(:job)
          params = { job_id: job.to_param }.merge(new_attributes)
          put :update, params: params
          expect(assigns(:job)).to eq(job)
        end

        it 'returns success status' do
          job = FactoryBot.create(:job, owner: owner)
          params = { job_id: job.to_param }.merge(new_attributes)
          put :update, params: params
          expect(response.status).to eq(200)
        end

        context 'cancelled job' do
          let(:new_attributes) do
            {
              auth_token: owner.auth_token,
              data: {
                attributes: { cancelled: true }
              }
            }
          end

          it 'sends cancelled notifications' do
            job = FactoryBot.create(:job, owner: owner)

            allow(JobCancelledNotifier).to receive(:call).and_return(nil)

            params = { job_id: job.to_param }.merge(new_attributes)
            put :update, params: params

            expect(JobCancelledNotifier).to have_received(:call).with(job: job)
          end
        end

        context 'locked job' do
          it 'returns for status' do
            job = FactoryBot.create(:job, owner: owner)
            FactoryBot.create(:job_user, job: job, accepted: true, will_perform: true)
            params = { job_id: job.to_param }.merge(new_attributes)
            put :update, params: params
            expect(response.status).to eq(403)
            parsed_json = JSON.parse(response.body)
            expect(parsed_json['errors'].first['status']).to eq(403)
          end
        end
      end

      context 'non associated user' do
        let(:new_attributes) do
          {
            auth_token: FactoryBot.create(:user_with_tokens).auth_token,
            data: {
              attributes: { hours: 6 }
            }
          }
        end

        it 'returns forbidden status' do
          FactoryBot.create(:user)
          user1 = FactoryBot.create(:company_user)
          user2 = FactoryBot.create(:user)
          job = FactoryBot.create(:job, owner: user1)
          FactoryBot.create(:job_user, user: user2, job: job)
          params = { job_id: job.to_param }.merge(new_attributes)
          put :update, params: params
          expect(response.status).to eq(403)
        end
      end
    end

    context 'with invalid params' do
      let(:job) do
        FactoryBot.create(:job, owner: owner)
      end

      it 'assigns the job as @job' do
        params = {
          auth_token: owner.auth_token,
          job_id: job.to_param
        }.merge(invalid_attributes)

        put :update, params: params
        expect(assigns(:job)).to eq(job)
      end

      it 'returns unprocessable entity status' do
        params = { job_id: job.to_param }.merge(invalid_attributes)
        params[:auth_token] = owner.auth_token

        put :update, params: params
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'GET #matching_users' do
    it 'returns 200 status if job owner' do
      job = FactoryBot.create(:published_job, owner: owner)
      params = { auth_token: owner.auth_token, job_id: job.to_param }
      get :show, params: params
      expect(response.status).to eq(200)
    end

    it 'returns 200 status if admin is user' do
      job = FactoryBot.create(:published_job)
      admin = FactoryBot.create(:user_with_tokens, admin: true)
      get :matching_users, params: { auth_token: admin.auth_token, job_id: job.to_param }
      expect(response.status).to eq(200)
    end

    it 'returns 401 unauthorized status when user not authorized' do
      job = FactoryBot.create(:published_job)
      get :matching_users, params: { job_id: job.to_param }
      expect(response.status).to eq(401)
    end
  end
end

# == Schema Information
#
# Table name: jobs
#
#  applicant_description        :text
#  blocketjobb_category         :string
#  cancelled                    :boolean          default(FALSE)
#  car_required                 :boolean          default(FALSE)
#  category_id                  :integer
#  city                         :string
#  cloned                       :boolean          default(FALSE)
#  company_contact_user_id      :integer
#  created_at                   :datetime         not null
#  customer_hourly_price        :decimal(, )
#  description                  :text
#  direct_recruitment_job       :boolean          default(FALSE)
#  featured                     :boolean          default(FALSE)
#  filled_at                    :datetime
#  full_time                    :boolean          default(FALSE)
#  hidden                       :boolean          default(FALSE)
#  hourly_pay_id                :integer
#  hours                        :float
#  id                           :integer          not null, primary key
#  invoice_comment              :text
#  job_date                     :datetime
#  job_end_date                 :datetime
#  just_arrived_contact_user_id :integer
#  language_id                  :integer
#  last_application_at          :datetime
#  latitude                     :float
#  longitude                    :float
#  metrojobb_category           :string
#  municipality                 :string
#  name                         :string
#  number_to_fill               :integer          default(1)
#  order_id                     :integer
#  owner_user_id                :integer
#  preview_key                  :string
#  publish_at                   :datetime
#  publish_on_blocketjobb       :boolean          default(FALSE)
#  publish_on_linkedin          :boolean          default(FALSE)
#  publish_on_metrojobb         :boolean          default(FALSE)
#  requirements_description     :text
#  salary_type                  :integer          default("fixed")
#  short_description            :string
#  staffing_company_id          :integer
#  staffing_job                 :boolean          default(FALSE)
#  street                       :string
#  swedish_drivers_license      :string
#  tasks_description            :text
#  unpublish_at                 :datetime
#  upcoming                     :boolean          default(FALSE)
#  updated_at                   :datetime         not null
#  zip                          :string
#  zip_latitude                 :float
#  zip_longitude                :float
#
# Indexes
#
#  index_jobs_on_category_id          (category_id)
#  index_jobs_on_hourly_pay_id        (hourly_pay_id)
#  index_jobs_on_language_id          (language_id)
#  index_jobs_on_order_id             (order_id)
#  index_jobs_on_staffing_company_id  (staffing_company_id)
#
# Foreign Keys
#
#  fk_rails_...                          (category_id => categories.id)
#  fk_rails_...                          (hourly_pay_id => hourly_pays.id)
#  fk_rails_...                          (language_id => languages.id)
#  fk_rails_...                          (order_id => orders.id)
#  jobs_company_contact_user_id_fk       (company_contact_user_id => users.id)
#  jobs_just_arrived_contact_user_id_fk  (just_arrived_contact_user_id => users.id)
#  jobs_owner_user_id_fk                 (owner_user_id => users.id)
#
