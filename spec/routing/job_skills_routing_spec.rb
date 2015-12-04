require "rails_helper"

RSpec.describe JobSkillsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/job_skills").to route_to("job_skills#index")
    end

    it "routes to #new" do
      expect(:get => "/job_skills/new").to route_to("job_skills#new")
    end

    it "routes to #show" do
      expect(:get => "/job_skills/1").to route_to("job_skills#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/job_skills/1/edit").to route_to("job_skills#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/job_skills").to route_to("job_skills#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/job_skills/1").to route_to("job_skills#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/job_skills/1").to route_to("job_skills#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/job_skills/1").to route_to("job_skills#destroy", :id => "1")
    end

  end
end
