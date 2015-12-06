require 'rails_helper'

RSpec.describe Api::V1::UserLanguagesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # UserLanguage. As you add validations to UserLanguage, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UserLanguagesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all user_languages as @user_languages" do
      user_language = UserLanguage.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:user_languages)).to eq([user_language])
    end
  end

  describe "GET #show" do
    it "assigns the requested user_language as @user_language" do
      user_language = UserLanguage.create! valid_attributes
      get :show, {:id => user_language.to_param}, valid_session
      expect(assigns(:user_language)).to eq(user_language)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new UserLanguage" do
        expect {
          post :create, {:user_language => valid_attributes}, valid_session
        }.to change(UserLanguage, :count).by(1)
      end

      it "assigns a newly created user_language as @user_language" do
        post :create, {:user_language => valid_attributes}, valid_session
        expect(assigns(:user_language)).to be_a(UserLanguage)
        expect(assigns(:user_language)).to be_persisted
      end

      it "redirects to the created user_language" do
        post :create, {:user_language => valid_attributes}, valid_session
        expect(response).to redirect_to(UserLanguage.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved user_language as @user_language" do
        post :create, {:user_language => invalid_attributes}, valid_session
        expect(assigns(:user_language)).to be_a_new(UserLanguage)
      end

      it "re-renders the 'new' template" do
        post :create, {:user_language => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested user_language" do
        user_language = UserLanguage.create! valid_attributes
        put :update, {:id => user_language.to_param, :user_language => new_attributes}, valid_session
        user_language.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested user_language as @user_language" do
        user_language = UserLanguage.create! valid_attributes
        put :update, {:id => user_language.to_param, :user_language => valid_attributes}, valid_session
        expect(assigns(:user_language)).to eq(user_language)
      end

      it "redirects to the user_language" do
        user_language = UserLanguage.create! valid_attributes
        put :update, {:id => user_language.to_param, :user_language => valid_attributes}, valid_session
        expect(response).to redirect_to(user_language)
      end
    end

    context "with invalid params" do
      it "assigns the user_language as @user_language" do
        user_language = UserLanguage.create! valid_attributes
        put :update, {:id => user_language.to_param, :user_language => invalid_attributes}, valid_session
        expect(assigns(:user_language)).to eq(user_language)
      end

      it "re-renders the 'edit' template" do
        user_language = UserLanguage.create! valid_attributes
        put :update, {:id => user_language.to_param, :user_language => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user_language" do
      user_language = UserLanguage.create! valid_attributes
      expect {
        delete :destroy, {:id => user_language.to_param}, valid_session
      }.to change(UserLanguage, :count).by(-1)
    end

    it "redirects to the user_languages list" do
      user_language = UserLanguage.create! valid_attributes
      delete :destroy, {:id => user_language.to_param}, valid_session
      expect(response).to redirect_to(user_languages_url)
    end
  end

end
