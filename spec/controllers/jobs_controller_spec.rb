# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::JobsController, type: :controller do
  let(:company) { FactoryGirl.create(:company) }
  let(:owner) { FactoryGirl.create(:user, company: company) }
  let(:valid_attributes) do
    {
      data: {
        attributes: {
          hours: 2,
          name: 'Some job name',
          short_description: 'Short description',
          description: 'Some job description',
          language_id: FactoryGirl.create(:language).id,
          hourly_pay_id: FactoryGirl.create(:hourly_pay).id,
          category_id: FactoryGirl.create(:category).id,
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
      data: {
        attributes: { hours: nil }
      }
    }
  end

  let(:valid_session) do
    user = FactoryGirl.create(:user_with_tokens, company: FactoryGirl.create(:company))
    allow_any_instance_of(described_class).
      to(receive(:current_user).
      and_return(user))
    { token: user.auth_token }
  end

  let(:valid_admin_session) do
    admin = FactoryGirl.create(:admin_user)
    allow_any_instance_of(described_class).
      to(receive(:current_user).
      and_return(admin))
    { token: admin.auth_token }
  end

  let(:invalid_session) do
    user = FactoryGirl.create(:user)
    allow_any_instance_of(described_class).
      to(receive(:current_user).
      and_return(User.new))
    { token: user.auth_token }
  end

  describe 'GET #index' do
    it 'assigns all jobs as @jobs' do
      job = FactoryGirl.create(:job)
      process :index, method: :get, headers: valid_session
      expect(assigns(:jobs)).to eq([job])
    end

    it 'returns sorted results' do
      FactoryGirl.create(:job, hours: 7)
      FactoryGirl.create(:job, hours: 10)
      FactoryGirl.create(:job, hours: 5)

      get :index, params: { sort: '-hours' }
      expect(response.status).to eq(200)
      parsed_body = JSON.parse(response.body)

      job_hours_count = parsed_body['data'].map do |job|
        job['attributes']['hours'].to_i
      end
      expect(job_hours_count).to eq([10, 7, 5])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested job as @job' do
      job = FactoryGirl.create(:job)
      get :show, params: { job_id: job.to_param }, headers: valid_session
      expect(assigns(:job)).to eq(job)
    end
  end

  describe 'POST #create' do
    let(:valid_session) do
      allow_any_instance_of(described_class).
        to(receive(:current_user).
        and_return(owner))
      { token: owner.auth_token }
    end

    context 'with valid params' do
      it 'creates a new Job' do
        expect do
          post :create, params: valid_attributes, headers: valid_session
        end.to change(Job, :count).by(1)
      end

      it '[deprecated] creates a new Job without owner_id in payload ' do
        valid_attributes[:data][:attributes][:owner_user_id] = nil
        expect do
          post :create, params: valid_attributes, headers: valid_session
        end.to change(Job, :count).by(1)
      end

      it 'works' do
        post :create, params: valid_attributes, headers: valid_session
        job = assigns(:job)

        expect(job.translations.length).to eq(1)
        expect(job).to be_a(Job)
        expect(job).to be_persisted
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved job as @job' do
        post :create, params: invalid_attributes, headers: valid_session
        expect(assigns(:job)).to be_a_new(Job)
      end

      it 'returns 422 status' do
        post :create, params: invalid_attributes, headers: valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_hours) { 8 }
      let(:new_attributes) do
        {
          data: {
            attributes: { hours: new_hours }
          }
        }
      end

      let(:user) { User.find_by_auth_token(valid_session[:token]) }

      context 'owner user' do
        it 'updates the requested job' do
          job = FactoryGirl.create(:job, owner: user)
          params = { job_id: job.to_param }.merge(new_attributes)
          put :update, params: params, headers: valid_session
          job.reload
          expect(job.hours).to eq(new_hours)
        end

        it 'assigns the requested user as @job' do
          job = FactoryGirl.create(:job)
          params = { job_id: job.to_param }.merge(new_attributes)
          put :update, params: params, headers: valid_session
          expect(assigns(:job)).to eq(job)
        end

        it 'returns success status' do
          job = FactoryGirl.create(:job, owner: user)
          params = { job_id: job.to_param }.merge(new_attributes)
          put :update, params: params, headers: valid_session
          expect(response.status).to eq(200)
        end

        context 'cancelled job' do
          let(:new_attributes) do
            {
              data: {
                attributes: { cancelled: true }
              }
            }
          end

          it 'sends cancelled notifications' do
            job = FactoryGirl.create(:job, owner: user)

            allow(JobCancelledNotifier).to receive(:call).and_return(nil)

            params = { job_id: job.to_param }.merge(new_attributes)
            put :update, params: params, headers: valid_session

            expect(JobCancelledNotifier).to have_received(:call).with(job: job)
          end
        end

        context 'locked job' do
          it 'returns for status' do
            job = FactoryGirl.create(:job, owner: user)
            FactoryGirl.create(:job_user, job: job, accepted: true, will_perform: true)
            params = { job_id: job.to_param }.merge(new_attributes)
            put :update, params: params, headers: valid_session
            expect(response.status).to eq(403)
            parsed_json = JSON.parse(response.body)
            expect(parsed_json['errors'].first['status']).to eq(403)
          end
        end
      end

      context 'non associated user' do
        let(:new_attributes) do
          {
            data: {
              attributes: { hours: 6 }
            }
          }
        end

        it 'returns forbidden status' do
          FactoryGirl.create(:user)
          user1 = FactoryGirl.create(:company_user)
          user2 = FactoryGirl.create(:user)
          job = FactoryGirl.create(:job, owner: user1)
          FactoryGirl.create(:job_user, user: user2, job: job)
          params = { job_id: job.to_param }.merge(new_attributes)
          put :update, params: params, headers: valid_session
          expect(response.status).to eq(403)
        end
      end

      context 'job user' do
        let(:new_attributes) do
          {
            data: {
              attributes: { hours: 6 }
            }
          }
        end

        let(:valid_session) do
          user = FactoryGirl.create(:user_with_tokens)
          allow_any_instance_of(described_class).
            to(receive(:current_user).
            and_return(user))
          { token: user.auth_token }
        end

        let(:user) { User.find_by_auth_token(valid_session[:token]) }

        it 'returns forbidden status' do
          FactoryGirl.create(:user)
          job = FactoryGirl.create(:job)
          FactoryGirl.create(:job_user, user: user, job: job)
          params = { job_id: job.to_param }.merge(new_attributes)
          put :update, params: params, headers: valid_session
          expect(response.status).to eq(403)
        end
      end
    end

    context 'with invalid params' do
      let(:job) do
        user = User.find_by_auth_token(valid_session[:token])
        FactoryGirl.create(:job, owner: user)
      end

      it 'assigns the job as @job' do
        params = { job_id: job.to_param }.merge(invalid_attributes)
        put :update, params: params, headers: valid_session
        expect(assigns(:job)).to eq(job)
      end

      it 'returns unprocessable entity status' do
        params = { job_id: job.to_param }.merge(invalid_attributes)
        put :update, params: params, headers: valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'GET #matching_users' do
    it 'returns 200 status if job owner' do
      job = FactoryGirl.create(:job)
      get :show, params: { job_id: job.to_param }, headers: valid_session
      expect(response.status).to eq(200)
    end

    it 'returns 200 status if admin is user' do
      job = FactoryGirl.create(:job)
      get :matching_users, params: { job_id: job.to_param }, headers: valid_admin_session
      expect(response.status).to eq(200)
    end

    it 'returns 401 unauthorized status when user not authorized' do
      job = FactoryGirl.create(:job)
      get :matching_users, params: { job_id: job.to_param }, headers: invalid_session
      expect(response.status).to eq(401)
    end
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id                           :integer          not null, primary key
#  description                  :text
#  job_date                     :datetime
#  hours                        :float
#  name                         :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  owner_user_id                :integer
#  latitude                     :float
#  longitude                    :float
#  language_id                  :integer
#  street                       :string
#  zip                          :string
#  zip_latitude                 :float
#  zip_longitude                :float
#  hidden                       :boolean          default(FALSE)
#  category_id                  :integer
#  hourly_pay_id                :integer
#  verified                     :boolean          default(FALSE)
#  job_end_date                 :datetime
#  cancelled                    :boolean          default(FALSE)
#  filled                       :boolean          default(FALSE)
#  short_description            :string
#  featured                     :boolean          default(FALSE)
#  upcoming                     :boolean          default(FALSE)
#  company_contact_user_id      :integer
#  just_arrived_contact_user_id :integer
#  city                         :string
#  staffing_job                 :boolean          default(FALSE)
#  direct_recruitment_job       :boolean          default(FALSE)
#  municipality                 :string
#  number_to_fill               :integer          default(1)
#  order_id                     :integer
#
# Indexes
#
#  index_jobs_on_category_id    (category_id)
#  index_jobs_on_hourly_pay_id  (hourly_pay_id)
#  index_jobs_on_language_id    (language_id)
#  index_jobs_on_order_id       (order_id)
#
# Foreign Keys
#
#  fk_rails_1cf0b3b406                   (category_id => categories.id)
#  fk_rails_70cb33aa57                   (language_id => languages.id)
#  fk_rails_b144fc917d                   (hourly_pay_id => hourly_pays.id)
#  fk_rails_ca13181750                   (order_id => orders.id)
#  jobs_company_contact_user_id_fk       (company_contact_user_id => users.id)
#  jobs_just_arrived_contact_user_id_fk  (just_arrived_contact_user_id => users.id)
#  jobs_owner_user_id_fk                 (owner_user_id => users.id)
#
