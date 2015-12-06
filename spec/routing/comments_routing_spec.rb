require "rails_helper"

RSpec.describe Api::V1::CommentsController, type: :routing do
  describe "routing jobs" do
    it "routes to #index" do
      expect(get: "/api/v1/jobs/1/comments").to route_to("api/v1/jobs/comments#index", job_id: "1")
    end

    it "routes to #show" do
      expect(get: "/api/v1/jobs/1/comments/1").to route_to("api/v1/jobs/comments#show", job_id: "1", id: "1")
    end

    it "routes to #create" do
      expect(post: "/api/v1/jobs/1/comments").to route_to("api/v1/jobs/comments#create", job_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/api/v1/jobs/1/comments/1").to route_to("api/v1/jobs/comments#update", job_id: "1", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api/v1/jobs/1/comments/1").to route_to("api/v1/jobs/comments#update", job_id: "1", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/api/v1/jobs/1/comments/1").to route_to("api/v1/jobs/comments#destroy", job_id: "1", id: "1")
    end
  end

  describe "routing users" do
    it "routes to #index" do
      expect(get: "/api/v1/users/1/comments").to route_to("api/v1/users/comments#index", user_id: "1")
    end

    it "routes to #show" do
      expect(get: "/api/v1/users/1/comments/1").to route_to("api/v1/users/comments#show", user_id: "1", id: "1")
    end

    it "routes to #create" do
      expect(post: "/api/v1/users/1/comments").to route_to("api/v1/users/comments#create", user_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/api/v1/users/1/comments/1").to route_to("api/v1/users/comments#update", user_id: "1", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api/v1/users/1/comments/1").to route_to("api/v1/users/comments#update", user_id: "1", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/api/v1/users/1/comments/1").to route_to("api/v1/users/comments#destroy", user_id: "1", id: "1")
    end
  end
end
