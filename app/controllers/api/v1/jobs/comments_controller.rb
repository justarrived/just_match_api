module Api
  module V1
    class Jobs::CommentsController < CommentsController
      before_action :set_commentable
      before_action :set_comment, only: [:show]

      private

      def set_commentable
        @commentable = Job.find(params[:job_id])
      end

      def set_comment
        @comment = @commentable.comments.find(params[:id])
      end
    end
  end
end
