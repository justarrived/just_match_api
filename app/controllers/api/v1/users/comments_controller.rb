class Api::V1::Users::CommentsController < Api::V1::CommentsController
  before_action :set_commentable
  before_action :set_comment, only: [:show]

  private

    def set_commentable
      @commentable = User.find(params[:user_id])
    end

    def set_comment
      @comment = @commentable.comments.find(params[:id])
    end
end
