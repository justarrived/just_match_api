require "rails_helper"

RSpec.describe UserSkillsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/user_skills").to route_to("user_skills#index")
    end

    it "routes to #new" do
      expect(:get => "/user_skills/new").to route_to("user_skills#new")
    end

    it "routes to #show" do
      expect(:get => "/user_skills/1").to route_to("user_skills#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/user_skills/1/edit").to route_to("user_skills#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/user_skills").to route_to("user_skills#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/user_skills/1").to route_to("user_skills#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/user_skills/1").to route_to("user_skills#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/user_skills/1").to route_to("user_skills#destroy", :id => "1")
    end

  end
end
