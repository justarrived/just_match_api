require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:valid_attributes) do
    lang_id = FactoryGirl.create(:language).id
    {
      skill_ids: [FactoryGirl.create(:skill).id],
      email: 'someone@example.com',
      name: 'Some user name',
      phone: '123456789',
      description: 'Some user description',
      language_id: lang_id,
      language_ids: [lang_id],
      address: 'Stora Nygatan 36, Malmö'
    }
  end

  let(:invalid_attributes) do
    { name: nil }
  end

  let(:valid_session) do
    user = FactoryGirl.create(:user)
    session = { token: user.auth_token }
  end

  describe 'GET #index' do
    it 'assigns all users as @users' do
      user = User.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:users)).to include(user)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user as @user' do
      user = User.create! valid_attributes
      get :show, { user_id: user.to_param }, valid_session
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect do
          post :create, { user: valid_attributes }, {}
        end.to change(User, :count).by(1)
      end

      it 'assigns a newly created user as @user' do
        post :create, { user: valid_attributes }, {}
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end

      it 'returns created status' do
        post :create, { user: valid_attributes }, {}
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved user as @user' do
        post :create, { user: invalid_attributes }, valid_session
        expect(assigns(:user)).to be_a_new(User)
      end

      it 'returns unprocessable entity status' do
        post :create, { user: invalid_attributes }, valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { phone: '987654321' }
      end

      context 'authorized' do
        before(:each) do
          @user = User.find_by(auth_token: valid_session[:token])
        end

        it 'updates the requested user' do
          put :update, { user_id: @user.to_param, user: new_attributes }, valid_session
          @user.reload
          expect(@user.phone).to eq('987654321')
        end

        it 'assigns the requested user as @user' do
          put :update, { user_id: @user.to_param, user: valid_attributes }, valid_session
          expect(assigns(:user)).to eq(@user)
        end

        it 'returns success status' do
          put :update, { user_id: @user.to_param, user: valid_attributes }, valid_session
          expect(response.status).to eq(200)
        end
      end

      context 'unauthorized' do
        let(:user) { FactoryGirl.create(:user) }

        it 'does not update the requested user' do
          put :update, { user_id: user.to_param, user: new_attributes }, {}
          user.reload
          expect(user.phone).to eq('1234567890')
        end

        it 'does not assign the requested user as user' do
          put :update, { user_id: user.to_param, user: valid_attributes }, valid_session
          expect(assigns(:user)).to eq(user)
        end

        it 'returns not authorized status' do
          put :update, { user_id: user.to_param, user: valid_attributes }, valid_session
          expect(response.status).to eq(401)
        end
      end
    end

    context 'with invalid params' do
      before(:each) do
        @user = User.find_by(auth_token: valid_session[:token])
      end

      it 'assigns the user as @user' do
        put :update, { user_id: @user.to_param, user: invalid_attributes }, valid_session
        expect(assigns(:user)).to eq(@user)
      end

      it 'returns unprocessable entity status' do
        put :update, { user_id: @user.to_param, user: invalid_attributes }, valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authorized' do
      before(:each) do
        @user = User.find_by(auth_token: valid_session[:token])
      end

      it 'destroys the requested user' do
        delete :destroy, { user_id: @user.to_param }, valid_session
        @user.reload
        expect(@user.name).to eq('Ghost')
      end

      it 'returns no content status' do
        delete :destroy, { user_id: @user.to_param }, valid_session
        expect(response.status).to eq(204)
      end
    end

    context 'unauthorized' do
      it 'does not destroy the requested user' do
        user = User.create! valid_attributes
        delete :destroy, { user_id: user.to_param }, valid_session
        user.reload
        expect(user.name).to eq('Some user name')
      end

      it 'returns not authorized status' do
        user = User.create! valid_attributes
        delete :destroy, { user_id: user.to_param }, valid_session
        expect(response.status).to eq(401)
      end
    end
  end
end
