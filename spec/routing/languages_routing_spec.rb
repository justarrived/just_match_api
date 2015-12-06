require "rails_helper"

RSpec.describe LanguagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/languages").to route_to("languages#index")
    end

    it "routes to #new" do
      expect(:get => "/languages/new").to route_to("languages#new")
    end

    it "routes to #show" do
      expect(:get => "/languages/1").to route_to("languages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/languages/1/edit").to route_to("languages#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/languages").to route_to("languages#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/languages/1").to route_to("languages#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/languages/1").to route_to("languages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/languages/1").to route_to("languages#destroy", :id => "1")
    end

  end
end
