require 'rails_helper'

RSpec.describe Api::V1::UserSkillsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # UserSkill. As you add validations to UserSkill, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UserSkillsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all user_skills as @user_skills" do
      user_skill = UserSkill.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:user_skills)).to eq([user_skill])
    end
  end

  describe "GET #show" do
    it "assigns the requested user_skill as @user_skill" do
      user_skill = UserSkill.create! valid_attributes
      get :show, {:id => user_skill.to_param}, valid_session
      expect(assigns(:user_skill)).to eq(user_skill)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new UserSkill" do
        expect {
          post :create, {:user_skill => valid_attributes}, valid_session
        }.to change(UserSkill, :count).by(1)
      end

      it "assigns a newly created user_skill as @user_skill" do
        post :create, {:user_skill => valid_attributes}, valid_session
        expect(assigns(:user_skill)).to be_a(UserSkill)
        expect(assigns(:user_skill)).to be_persisted
      end

      it "redirects to the created user_skill" do
        post :create, {:user_skill => valid_attributes}, valid_session
        expect(response).to redirect_to(UserSkill.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved user_skill as @user_skill" do
        post :create, {:user_skill => invalid_attributes}, valid_session
        expect(assigns(:user_skill)).to be_a_new(UserSkill)
      end

      it "re-renders the 'new' template" do
        post :create, {:user_skill => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested user_skill" do
        user_skill = UserSkill.create! valid_attributes
        put :update, {:id => user_skill.to_param, :user_skill => new_attributes}, valid_session
        user_skill.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested user_skill as @user_skill" do
        user_skill = UserSkill.create! valid_attributes
        put :update, {:id => user_skill.to_param, :user_skill => valid_attributes}, valid_session
        expect(assigns(:user_skill)).to eq(user_skill)
      end

      it "redirects to the user_skill" do
        user_skill = UserSkill.create! valid_attributes
        put :update, {:id => user_skill.to_param, :user_skill => valid_attributes}, valid_session
        expect(response).to redirect_to(user_skill)
      end
    end

    context "with invalid params" do
      it "assigns the user_skill as @user_skill" do
        user_skill = UserSkill.create! valid_attributes
        put :update, {:id => user_skill.to_param, :user_skill => invalid_attributes}, valid_session
        expect(assigns(:user_skill)).to eq(user_skill)
      end

      it "re-renders the 'edit' template" do
        user_skill = UserSkill.create! valid_attributes
        put :update, {:id => user_skill.to_param, :user_skill => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user_skill" do
      user_skill = UserSkill.create! valid_attributes
      expect {
        delete :destroy, {:id => user_skill.to_param}, valid_session
      }.to change(UserSkill, :count).by(-1)
    end

    it "redirects to the user_skills list" do
      user_skill = UserSkill.create! valid_attributes
      delete :destroy, {:id => user_skill.to_param}, valid_session
      expect(response).to redirect_to(user_skills_url)
    end
  end

end
