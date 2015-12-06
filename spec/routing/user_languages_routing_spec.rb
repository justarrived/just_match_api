require "rails_helper"

RSpec.describe UserLanguagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/user_languages").to route_to("user_languages#index")
    end

    it "routes to #new" do
      expect(:get => "/user_languages/new").to route_to("user_languages#new")
    end

    it "routes to #show" do
      expect(:get => "/user_languages/1").to route_to("user_languages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/user_languages/1/edit").to route_to("user_languages#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/user_languages").to route_to("user_languages#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/user_languages/1").to route_to("user_languages#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/user_languages/1").to route_to("user_languages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/user_languages/1").to route_to("user_languages#destroy", :id => "1")
    end

  end
end
