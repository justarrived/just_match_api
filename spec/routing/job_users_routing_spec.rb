require "rails_helper"

RSpec.describe JobUsersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/job_users").to route_to("job_users#index")
    end

    it "routes to #new" do
      expect(:get => "/job_users/new").to route_to("job_users#new")
    end

    it "routes to #show" do
      expect(:get => "/job_users/1").to route_to("job_users#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/job_users/1/edit").to route_to("job_users#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/job_users").to route_to("job_users#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/job_users/1").to route_to("job_users#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/job_users/1").to route_to("job_users#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/job_users/1").to route_to("job_users#destroy", :id => "1")
    end

  end
end
