require 'rails_helper'

RSpec.describe Api::V1::JobSkillsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # JobSkill. As you add validations to JobSkill, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # JobSkillsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all job_skills as @job_skills" do
      job_skill = JobSkill.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:job_skills)).to eq([job_skill])
    end
  end

  describe "GET #show" do
    it "assigns the requested job_skill as @job_skill" do
      job_skill = JobSkill.create! valid_attributes
      get :show, {:id => job_skill.to_param}, valid_session
      expect(assigns(:job_skill)).to eq(job_skill)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new JobSkill" do
        expect {
          post :create, {:job_skill => valid_attributes}, valid_session
        }.to change(JobSkill, :count).by(1)
      end

      it "assigns a newly created job_skill as @job_skill" do
        post :create, {:job_skill => valid_attributes}, valid_session
        expect(assigns(:job_skill)).to be_a(JobSkill)
        expect(assigns(:job_skill)).to be_persisted
      end

      it "redirects to the created job_skill" do
        post :create, {:job_skill => valid_attributes}, valid_session
        expect(response).to redirect_to(JobSkill.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved job_skill as @job_skill" do
        post :create, {:job_skill => invalid_attributes}, valid_session
        expect(assigns(:job_skill)).to be_a_new(JobSkill)
      end

      it "re-renders the 'new' template" do
        post :create, {:job_skill => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested job_skill" do
        job_skill = JobSkill.create! valid_attributes
        put :update, {:id => job_skill.to_param, :job_skill => new_attributes}, valid_session
        job_skill.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested job_skill as @job_skill" do
        job_skill = JobSkill.create! valid_attributes
        put :update, {:id => job_skill.to_param, :job_skill => valid_attributes}, valid_session
        expect(assigns(:job_skill)).to eq(job_skill)
      end

      it "redirects to the job_skill" do
        job_skill = JobSkill.create! valid_attributes
        put :update, {:id => job_skill.to_param, :job_skill => valid_attributes}, valid_session
        expect(response).to redirect_to(job_skill)
      end
    end

    context "with invalid params" do
      it "assigns the job_skill as @job_skill" do
        job_skill = JobSkill.create! valid_attributes
        put :update, {:id => job_skill.to_param, :job_skill => invalid_attributes}, valid_session
        expect(assigns(:job_skill)).to eq(job_skill)
      end

      it "re-renders the 'edit' template" do
        job_skill = JobSkill.create! valid_attributes
        put :update, {:id => job_skill.to_param, :job_skill => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested job_skill" do
      job_skill = JobSkill.create! valid_attributes
      expect {
        delete :destroy, {:id => job_skill.to_param}, valid_session
      }.to change(JobSkill, :count).by(-1)
    end

    it "redirects to the job_skills list" do
      job_skill = JobSkill.create! valid_attributes
      delete :destroy, {:id => job_skill.to_param}, valid_session
      expect(response).to redirect_to(job_skills_url)
    end
  end

end
