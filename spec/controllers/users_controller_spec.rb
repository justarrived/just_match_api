# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:valid_attributes) do
    lang_id = FactoryGirl.create(:language).id
    {
      data: {
        attributes: {
          skill_ids: [FactoryGirl.create(:skill).id],
          email: 'someone@example.com',
          first_name: 'Some user',
          last_name: 'name',
          phone: '123456789',
          description: 'Some user description',
          language_id: lang_id,
          language_ids: [lang_id],
          street: 'Stora Nygatan 36',
          zip: '211 37',
          password: (1..8).to_a.join,
          ssn: '8901010000'
        }
      }
    }
  end

  let(:invalid_attributes) do
    {
      data: {
        attributes: { first_name: nil }
      }
    }
  end

  let(:logged_in_user) { FactoryGirl.create(:user) }

  let(:valid_session) do
    allow_any_instance_of(described_class).
      to(receive(:authenticate_user_token!).
      and_return(logged_in_user))
    { token: logged_in_user.auth_token }
  end

  let(:valid_admin_session) do
    user = FactoryGirl.create(:user, admin: true)
    allow_any_instance_of(described_class).
      to(receive(:authenticate_user_token!).
      and_return(user))
    { token: user.auth_token }
  end

  describe 'GET #index' do
    it 'assigns all users as @users' do
      user = FactoryGirl.create(:user)
      get :index, {}, valid_admin_session
      expect(assigns(:users)).to include(user)
    end

    context 'not authorized' do
      it 'does not assigns all users as @users' do
        FactoryGirl.create(:user)
        get :index, {}, {}
        expect(assigns(:users)).to eq(nil)
      end

      it 'returns 401 status' do
        FactoryGirl.create(:user)
        get :index, {}, {}
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user as @user' do
      user = FactoryGirl.create(:user)
      get :show, { user_id: user.to_param }, valid_session
      expect(assigns(:user)).to eq(user)
    end

    it 'returns 401 status' do
      user = FactoryGirl.create(:user)
      get :show, { user_id: user.to_param }, {}
      expect(response.status).to eq(401)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect do
          post :create, valid_attributes, {}
        end.to change(User, :count).by(1)
      end

      it 'assigns a newly created user as @user' do
        post :create, valid_attributes, {}
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end

      it 'returns created status' do
        post :create, valid_attributes, {}
        expect(response.status).to eq(201)
      end

      it 'sends welcome notification' do
        allow(UserWelcomeNotifier).to receive(:call)
        post :create, valid_attributes, {}
        expect(UserWelcomeNotifier).to have_received(:call)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved user as @user' do
        post :create, invalid_attributes, valid_session
        expect(assigns(:user)).to be_a_new(User)
      end

      it 'returns unprocessable entity status' do
        post :create, invalid_attributes, valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          data: {
            attributes: { phone: '987654321' }
          }
        }
      end

      context 'authorized' do
        let(:user) { User.find_by(auth_token: valid_session[:token]) }

        it 'updates the requested user' do
          params = { user_id: user.to_param }.merge(new_attributes)
          put :update, params, valid_session
          user.reload
          expect(user.phone).to eq('987654321')
        end

        it 'assigns the requested user as @user' do
          params = { user_id: user.to_param }.merge(new_attributes)
          put :update, params, valid_session
          expect(assigns(:user)).to eq(user)
        end

        it 'returns success status' do
          params = { user_id: user.to_param }.merge(new_attributes)
          put :update, params, valid_session
          expect(response.status).to eq(200)
        end
      end

      context 'unauthorized' do
        let(:user) { FactoryGirl.create(:user) }

        it 'does not update the requested user' do
          params = { user_id: user.to_param }.merge(new_attributes)
          put :update, params, {}
          user.reload
          expect(user.phone).to eq('1234567890')
        end

        it 'does not assign the requested user as user' do
          params = { user_id: user.to_param }.merge(new_attributes)
          put :update, params, {}
          expect(assigns(:user)).to eq(user)
        end

        it 'returns not authorized status' do
          params = { user_id: user.to_param }.merge(new_attributes)
          put :update, params, {}
          expect(response.status).to eq(401)
        end
      end
    end

    context 'with invalid params' do
      let(:user) { User.find_by(auth_token: valid_session[:token]) }

      it 'assigns the user as @user' do
        params = { user_id: user.to_param }.merge(invalid_attributes)
        put :update, params, valid_session
        expect(assigns(:user)).to eq(user)
      end

      it 'returns unprocessable entity status' do
        params = { user_id: user.to_param }.merge(invalid_attributes)
        put :update, params, valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authorized' do
      let(:user) { User.find_by(auth_token: valid_session[:token]) }

      it 'destroys the requested user' do
        delete :destroy, { user_id: user.to_param }, valid_session
        user.reload
        expect(user.name).to eq('Ghost user')
      end

      it 'returns no content status' do
        delete :destroy, { user_id: user.to_param }, valid_session
        expect(response.status).to eq(204)
      end
    end

    context 'unauthorized' do
      it 'does not destroy the requested user' do
        first_name = 'Some user'

        user = FactoryGirl.create(:user, first_name: first_name)
        delete :destroy, { user_id: user.to_param }, valid_session
        user.reload
        expect(user.first_name).to eq(first_name)
      end

      it 'returns not authorized status' do
        user = FactoryGirl.create(:user)
        delete :destroy, { user_id: user.to_param }, valid_session
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'GET #jobs' do
    it 'assigns all jobs as @jobs' do
      job = FactoryGirl.create(:job)
      FactoryGirl.create(:job_user, job: job, user: logged_in_user)
      get :jobs, { user_id: logged_in_user.to_param }, valid_session
      expect(assigns(:jobs).first).to be_a(Job)
    end

    it 'assigns all jobs as @jobs' do
      job = FactoryGirl.create(:job)
      FactoryGirl.create(:job_user, job: job, user: logged_in_user)
      get :jobs, { user_id: logged_in_user.to_param }, valid_session
      expect(assigns(:jobs).first).to be_a(Job)
    end

    it 'returns unauthorized status when not allowed' do
      user = FactoryGirl.create(:user)
      get :jobs, { user_id: user.to_param }, valid_session
      expect(response.status).to eq(401)
    end
  end

  describe 'GET #matching_jobs' do
    it 'returns 200 status for admin user' do
      user = FactoryGirl.create(:user)
      get :show, { user_id: user.to_param }, valid_admin_session
      expect(response.status).to eq(200)
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  email         :string
#  phone         :string
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  latitude      :float
#  longitude     :float
#  language_id   :integer
#  anonymized    :boolean          default(FALSE)
#  auth_token    :string
#  password_hash :string
#  password_salt :string
#  admin         :boolean          default(FALSE)
#  street        :string
#  zip           :string
#  zip_latitude  :float
#  zip_longitude :float
#  first_name    :string
#  last_name     :string
#  ssn           :string
#  company_id    :integer
#
# Indexes
#
#  index_users_on_auth_token   (auth_token) UNIQUE
#  index_users_on_company_id   (company_id)
#  index_users_on_email        (email) UNIQUE
#  index_users_on_language_id  (language_id)
#  index_users_on_ssn          (ssn) UNIQUE
#
# Foreign Keys
#
#  fk_rails_45f4f12508  (language_id => languages.id)
#  fk_rails_7682a3bdfe  (company_id => companies.id)
#
