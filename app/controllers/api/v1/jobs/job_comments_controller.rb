# frozen_string_literal: true
module Api
  module V1
    module Jobs
      class JobCommentsController < Api::V1::CommentsController
        before_action :set_commentable
        before_action :set_comment, only: [:show]

        after_action :verify_authorized, only: []

        private

        def set_commentable
          @commentable = policy_scope(Job).find(params[:job_id])
        end

        def set_comment
          @comment = @commentable.comments.find(params[:id])
        end
      end
    end
  end
end
