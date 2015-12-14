class Api::V1::CommentsController < Api::V1::BaseController
  # NOTE: All API documentation for this Controller exists in users/comments_controller

  resource_description do
    api_versions '1.0'
    name 'Comments'
    short 'API for managing comments for various resources'
    description '
      Comments are polymorphic, which means they can belong to different types
      of resources, i.e jobs. Currently the only resource that has comments is `Job`.

      So where ever you see `:resource_name` you replace it with for example
      `jobs` and replace `:resource_id` with the job id.
    '
    formats [:json]
  end

  api :GET, '/:resource_name/:resource_id/comments', 'List comments'
  description 'Returns a list of comments.'
  def index
    page_index = params[:page].to_i
    @comments = @commentable.comments.page(page_index)

    render json: @comments
  end

  api :GET, '/:resource_name/:resource_id/comments/:id', 'Show comment'
  description 'Returns comment.'
  example Doxxer.example_for(Comment)
  def show
    render json: @comment
  end

  api :POST, '/:resource_name/:resource_id/comments/', 'Create new comment'
  description 'Creates and returns the new comment if the user is allowed to.'
  param :comment, Hash, desc: 'Comment attributes', required: true do
    param :body, String, desc: 'Body of the comment', required: true
    param :language_id, Integer, desc: 'Language id of the body content', required: true
    param :commentable_id, String, desc: 'Id of the owner resource', required: true
    param :commentable_type, String, desc: 'Owner resource type, i.e "jobs"', required: true
  end
  example Doxxer.example_for(Comment)
  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.owner_user_id = current_user.id

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  api :PATCH, '/:resource_name/:resource_id/comments/:id', 'Update comment'
  description 'Updates and returns the comment if the user is allowed to.'
  param :comment, Hash, desc: 'Comment attributes', required: true do
    param :body, String, desc: 'Body of the comment'
    param :language_id, Integer, desc: 'Language id of the body content'
  end
  example Doxxer.example_for(Comment)
  def update
    @comment = current_user.written_comments.find(params[:id])
    @comment.body = comment_params[:body]

    if @comment.save
      render json: @comment, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/:resource_name/:resource_id/comments/:id', 'Delete comment'
  description 'Deletes comment if allowed.'
  def destroy
    @comment = current_user.written_comments.find(params[:id])
    @comment.destroy

    head :no_content
  end

  private

    def comment_params
      params.require(:comment).permit(:body)
    end
end
