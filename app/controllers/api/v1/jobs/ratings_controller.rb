# frozen_string_literal: true
module Api
  module V1
    module Jobs
      class RatingsController < BaseController
        before_action :set_job

        resource_description do
          resource_id 'ratings'
          api_versions '1.0'
          name 'Ratings'
          short 'API for managing job ratings'
          description '
            Here you can find the documentation for inteteracting with ratings.
          '
          formats [:json]
        end

        api :POST, '/jobs/:job_id/ratings', 'Create new job rating.'
        description 'Creates and returns new rating.'
        error code: 400, desc: 'Bad request'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Rating attributes', required: true do
            param :score, Rating::SCORE_RANGE.to_a, desc: 'Rating score', required: true
            param :body, String, desc: 'Comment body', required: true
            param :language_id, Integer, desc: 'Language id', required: true
            param :user_id, Integer, desc: 'User id (receiver of rating)', required: true
          end
        end
        example Doxxer.read_example(Rating)
        def create
          authorize(Rating)

          @rating = Rating.new(rating_params)
          @rating.job = @job

          @rating.from_user = current_user
          @rating.to_user = User.find_by(jsonapi_params[:user_id])

          comment_params = {
            language_id: jsonapi_params[:language_id],
            body: jsonapi_params[:body],
            owner: current_user
          }
          @rating.comment = Comment.new(comment_params)

          if @rating.save
            api_render(@rating, included: %w(comment), status: :created)
          else
            respond_with_errors(@rating)
          end
        end

        private

        def set_job
          @job = Job.find(params[:job_id])
        end

        def rating_params
          jsonapi_params.permit(:score)
        end

        def pundit_user
          RatingPolicy::Context.new(current_user, @job)
        end
      end
    end
  end
end
