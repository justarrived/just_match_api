class Api::V1::Users::CommentsController < Api::V1::CommentsController
  before_action :set_commentable
  before_action :set_comment, only: [:show]

  api :GET, '/:resource_name/:resource_id/comments', 'List comments'
  description 'Returns a list of comments.'
  formats ['json']
  def index
    super
  end

  api :GET, '/:resource_name/:resource_id/comments/:id', 'Show comment'
  description 'Returns comment.'
  formats ['json']
  def show
    super
  end

  api :POST, '/:resource_name/:resource_id/comments/', 'Create new comment'
  description 'Creates and returns the new comment if the user is allowed to.'
  formats ['json']
  param :comment, Hash, desc: 'Comment attributes', required: true do
    param :body, String, desc: 'Body of the comment', required: true
    param :commentable_id, String, desc: 'Id of the owner resource', required: true
    param :commentable_type, String, desc: 'Owner resource type, i.e "jobs"', required: true
  end
  def create
    super
  end

  api :PATCH, '/:resource_name/:resource_id/comments/:id', 'Update new comment'
  description 'Updates and returns the comment if the user is allowed to.'
  formats ['json']
  param :comment, Hash, desc: 'Comment attributes', required: true do
    param :body, String, desc: 'Body of the comment'
  end
  def update
    super
  end

  api :DELETE, '/:resource_name/:resource_id/comments/:id', 'Delete comment'
  description 'Deletes comment if allowed.'
  formats ['json']
  def destroy
    super
  end

  private

    def set_commentable
      @commentable = User.find(params[:user_id])
    end

    def set_comment
      @comment = @commentable.comments.find(params[:id])
    end
end
