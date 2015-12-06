class Api::V1::CommentsController < ApplicationController
  api :GET, '/:resource_name/:resource_id/comments', 'List comments'
  description 'Returns a list of comments.'
  formats ['json']
  def index
    @comments = @commentable.comments

    render json: @comments
  end

  api :GET, '/:resource_name/:resource_id/comments/:id', 'Show comment'
  description 'Returns comment.'
  formats ['json']
  def show
    render json: @comment
  end

  api :POST, '/:resource_name/:resource_id/comments/', 'Create new comment'
  description 'Creates and returns the new comment.'
  formats ['json']
  param :comment, Hash, desc: 'Comment attributes', required: true do
    param :body, String, desc: 'Body of the comment', required: true
    param :commentable_id, String, desc: 'Id of the owner resource', required: true
    param :commentable_type, String, desc: 'Owner resource type, i.e "jobs"', required: true
  end
  def create
    @comment = @commentable.comments.new(comment_params)

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  api :PATCH, '/:resource_name/:resource_id/comments/:id', 'Update new comment'
  description 'Updates and returns the comment.'
  formats ['json']
  param :comment, Hash, desc: 'Comment attributes', required: true do
    param :body, String, desc: 'Body of the comment'
  end
  def update
    @comment = Comment.find(params[:id])
    @comment.body = comment_params[:body]

    if @comment.save
      render json: @comment, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/:resource_name/:resource_id/comments/:id', 'Delete comment'
  description 'Deletes comment.'
  formats ['json']
  def destroy
    @comment.destroy

    head :no_content
  end

  private

    def comment_params
      params.require(:comment).permit(:body, :owner_user_id)
    end
end
