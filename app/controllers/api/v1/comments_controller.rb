class Api::V1::CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :update, :destroy]

  api :GET, '/comments', 'List comments'
  description 'Returns a list of comments.'
  formats ['json']
  def index
    @comments = Comment.all

    render json: @comments
  end

  api :GET, '/comments/:id', 'Show comment'
  description 'Returns comment.'
  formats ['json']
  def show
    render json: @comment
  end

  api :POST, '/comments/', 'Create new comment'
  description 'Creates and returns the new comment.'
  formats ['json']
  param :comment, Hash, desc: 'Comment attributes', required: true do
    param :body, String, desc: 'Body of the comment', required: true
    param :commentable_id, String, desc: 'Id of the owner resource', required: true
    param :commentable_type, String, desc: 'Owner resource type, i.e "jobs"', required: true
  end
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  api :PATCH, '/comments/:id', 'Update new comment'
  description 'Updates and returns the comment.'
  formats ['json']
  param :comment, Hash, desc: 'Comment attributes', required: true do
    param :body, String, desc: 'Body of the comment'
  end
  def update
    @comment = Comment.find(params[:id])
    comment.body = comment_params[:body]

    if @comment.save
      head :no_content
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/comments/:id', 'Delete comment'
  description 'Deletes comment.'
  formats ['json']
  def destroy
    @comment.destroy

    head :no_content
  end

  private

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:body, :user_id, :commentable_id, :commentable_type)
    end
end
