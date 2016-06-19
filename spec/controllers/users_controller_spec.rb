# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:valid_attributes) do
    lang_id = Language.find_or_create_by!(lang_code: 'en').id
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

      context 'user image' do
        let(:user_image) { FactoryGirl.create(:user_image) }

        it 'can add user image' do
          token = user_image.one_time_token

          valid_attributes[:data][:attributes][:user_image_one_time_token] = token

          post :create, valid_attributes, {}
          expect(assigns(:user).user_images.first).to eq(user_image)
        end

        it 'does not create user image if invalid one time token' do
          valid_attributes[:data][:attributes][:user_image_one_time_token] = 'token'

          post :create, valid_attributes, {}
          expect(assigns(:user).user_images.first).to be_nil
        end
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
            attributes: { first_name: 'Johanna' }
          }
        }
      end

      context 'authorized' do
        let(:user) { User.find_by(auth_token: valid_session[:token]) }

        it 'updates the requested user' do
          params = { user_id: user.to_param }.merge(new_attributes)
          put :update, params, valid_session
          user.reload
          expect(user.first_name).to eq('Johanna')
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

        context 'user image' do
          let(:user_image) { FactoryGirl.create(:user_image) }
          let(:new_attributes) do
            {
              data: {
                attributes: { user_image_one_time_token: user_image.one_time_token }
              }
            }
          end

          it 'can replace user image' do
            user.user_images = [FactoryGirl.create(:user_image)]

            params = { user_id: user.to_param }.merge(new_attributes)
            user_image.one_time_token
            post :update, params, {}
            expect(assigns(:user).user_images.first).to eq(user_image)
          end

          it 'does not replace user image if invalid one time token' do
            first_user_image = FactoryGirl.create(:user_image)
            user.user_images = [first_user_image]

            params = { user_id: user.to_param }

            post :update, params, {}
            expect(assigns(:user).user_images.first).to eq(first_user_image)
          end
        end
      end

      context 'unauthorized' do
        let(:user) { FactoryGirl.create(:user) }

        it 'does not update the requested user' do
          old_name = user.first_name
          params = { user_id: user.to_param }.merge(new_attributes)
          put :update, params, {}
          user.reload
          expect(user.first_name).to eq(old_name)
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

  describe 'GET #matching_jobs' do
    it 'returns 200 status for admin user' do
      user = FactoryGirl.create(:user)
      get :show, { user_id: user.to_param }, valid_admin_session
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #notifications' do
    it 'returns 200 status' do
      user = FactoryGirl.create(:user)
      get :notifications, { user_id: user.to_param }, {}
      expect(response.status).to eq(200)
    end

    it 'correct response body' do
      user = FactoryGirl.create(:user)
      get :notifications, { user_id: user.to_param }, {}

      result = JSON.parse(response.body)['data']
      result.each do |json_object|
        id = json_object['id']
        description = json_object.dig('attributes', 'description')
        type = json_object['type']

        expect(description).to eq(I18n.t("notifications.#{id}"))
        expect(type).to eq('user-notifications')
        expect(User::NOTIFICATIONS).to include(id)
      end
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                             :integer          not null, primary key
#  email                          :string
#  phone                          :string
#  description                    :text
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  latitude                       :float
#  longitude                      :float
#  language_id                    :integer
#  anonymized                     :boolean          default(FALSE)
#  auth_token                     :string
#  password_hash                  :string
#  password_salt                  :string
#  admin                          :boolean          default(FALSE)
#  street                         :string
#  zip                            :string
#  zip_latitude                   :float
#  zip_longitude                  :float
#  first_name                     :string
#  last_name                      :string
#  ssn                            :string
#  company_id                     :integer
#  banned                         :boolean          default(FALSE)
#  job_experience                 :text
#  education                      :text
#  one_time_token                 :string
#  one_time_token_expires_at      :datetime
#  ignored_notifications_mask     :integer
#  frilans_finans_id              :integer
#  frilans_finans_payment_details :boolean          default(FALSE)
#  competence_text                :text
#
# Indexes
#
#  index_users_on_auth_token         (auth_token) UNIQUE
#  index_users_on_company_id         (company_id)
#  index_users_on_email              (email) UNIQUE
#  index_users_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#  index_users_on_language_id        (language_id)
#  index_users_on_one_time_token     (one_time_token) UNIQUE
#  index_users_on_ssn                (ssn) UNIQUE
#
# Foreign Keys
#
#  fk_rails_45f4f12508  (language_id => languages.id)
#  fk_rails_7682a3bdfe  (company_id => companies.id)
#
