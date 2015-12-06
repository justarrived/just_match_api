require 'rails_helper'

RSpec.describe Api::V1::JobUsersController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # JobUser. As you add validations to JobUser, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # JobUsersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all job_users as @job_users" do
      job_user = JobUser.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:job_users)).to eq([job_user])
    end
  end

  describe "GET #show" do
    it "assigns the requested job_user as @job_user" do
      job_user = JobUser.create! valid_attributes
      get :show, {:id => job_user.to_param}, valid_session
      expect(assigns(:job_user)).to eq(job_user)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new JobUser" do
        expect {
          post :create, {:job_user => valid_attributes}, valid_session
        }.to change(JobUser, :count).by(1)
      end

      it "assigns a newly created job_user as @job_user" do
        post :create, {:job_user => valid_attributes}, valid_session
        expect(assigns(:job_user)).to be_a(JobUser)
        expect(assigns(:job_user)).to be_persisted
      end

      it "redirects to the created job_user" do
        post :create, {:job_user => valid_attributes}, valid_session
        expect(response).to redirect_to(JobUser.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved job_user as @job_user" do
        post :create, {:job_user => invalid_attributes}, valid_session
        expect(assigns(:job_user)).to be_a_new(JobUser)
      end

      it "re-renders the 'new' template" do
        post :create, {:job_user => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested job_user" do
        job_user = JobUser.create! valid_attributes
        put :update, {:id => job_user.to_param, :job_user => new_attributes}, valid_session
        job_user.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested job_user as @job_user" do
        job_user = JobUser.create! valid_attributes
        put :update, {:id => job_user.to_param, :job_user => valid_attributes}, valid_session
        expect(assigns(:job_user)).to eq(job_user)
      end

      it "redirects to the job_user" do
        job_user = JobUser.create! valid_attributes
        put :update, {:id => job_user.to_param, :job_user => valid_attributes}, valid_session
        expect(response).to redirect_to(job_user)
      end
    end

    context "with invalid params" do
      it "assigns the job_user as @job_user" do
        job_user = JobUser.create! valid_attributes
        put :update, {:id => job_user.to_param, :job_user => invalid_attributes}, valid_session
        expect(assigns(:job_user)).to eq(job_user)
      end

      it "re-renders the 'edit' template" do
        job_user = JobUser.create! valid_attributes
        put :update, {:id => job_user.to_param, :job_user => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested job_user" do
      job_user = JobUser.create! valid_attributes
      expect {
        delete :destroy, {:id => job_user.to_param}, valid_session
      }.to change(JobUser, :count).by(-1)
    end

    it "redirects to the job_users list" do
      job_user = JobUser.create! valid_attributes
      delete :destroy, {:id => job_user.to_param}, valid_session
      expect(response).to redirect_to(job_users_url)
    end
  end

end
