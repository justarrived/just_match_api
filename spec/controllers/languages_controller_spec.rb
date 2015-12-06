require 'rails_helper'

RSpec.describe Api::V1::LanguagesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Language. As you add validations to Language, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LanguagesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all languages as @languages" do
      language = Language.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:languages)).to eq([language])
    end
  end

  describe "GET #show" do
    it "assigns the requested language as @language" do
      language = Language.create! valid_attributes
      get :show, {:id => language.to_param}, valid_session
      expect(assigns(:language)).to eq(language)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Language" do
        expect {
          post :create, {:language => valid_attributes}, valid_session
        }.to change(Language, :count).by(1)
      end

      it "assigns a newly created language as @language" do
        post :create, {:language => valid_attributes}, valid_session
        expect(assigns(:language)).to be_a(Language)
        expect(assigns(:language)).to be_persisted
      end

      it "redirects to the created language" do
        post :create, {:language => valid_attributes}, valid_session
        expect(response).to redirect_to(Language.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved language as @language" do
        post :create, {:language => invalid_attributes}, valid_session
        expect(assigns(:language)).to be_a_new(Language)
      end

      it "re-renders the 'new' template" do
        post :create, {:language => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested language" do
        language = Language.create! valid_attributes
        put :update, {:id => language.to_param, :language => new_attributes}, valid_session
        language.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested language as @language" do
        language = Language.create! valid_attributes
        put :update, {:id => language.to_param, :language => valid_attributes}, valid_session
        expect(assigns(:language)).to eq(language)
      end

      it "redirects to the language" do
        language = Language.create! valid_attributes
        put :update, {:id => language.to_param, :language => valid_attributes}, valid_session
        expect(response).to redirect_to(language)
      end
    end

    context "with invalid params" do
      it "assigns the language as @language" do
        language = Language.create! valid_attributes
        put :update, {:id => language.to_param, :language => invalid_attributes}, valid_session
        expect(assigns(:language)).to eq(language)
      end

      it "re-renders the 'edit' template" do
        language = Language.create! valid_attributes
        put :update, {:id => language.to_param, :language => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested language" do
      language = Language.create! valid_attributes
      expect {
        delete :destroy, {:id => language.to_param}, valid_session
      }.to change(Language, :count).by(-1)
    end

    it "redirects to the languages list" do
      language = Language.create! valid_attributes
      delete :destroy, {:id => language.to_param}, valid_session
      expect(response).to redirect_to(languages_url)
    end
  end

end
