# frozen_string_literal: true
module Api
  module V1
    class CommentsController < BaseController
      resource_description do
        api_versions '1.0'
        name 'Comments'
        short 'API for managing comments for various resources'
        description '
          Comments are polymorphic, which means they can belong to different types
          of resources, i.e jobs.

          So where ever you see `:resource_name` you replace it with for example
          `jobs` and replace `:resource_id` with the job id.
        '
        formats [:json]
      end

      ALLOWED_INCLUDES = %w(language owner).freeze

      api :GET, '/:resource_name/:resource_id/comments', 'List comments'
      description 'Returns a list of comments.'
      error code: 404, desc: 'Not found'
      ApipieDocHelper.params(self, Index::CommentsIndex)
      example Doxxer.read_example(Comment, plural: true)
      def index
        comments_index = Index::CommentsIndex.new(self)
        @comments = comments_index.comments(@commentable.comments)

        api_render(@comments, total: comments_index.count)
      end

      api :GET, '/:resource_name/:resource_id/comments/:id', 'Show comment'
      description 'Returns comment.'
      error code: 404, desc: 'Not found'
      ApipieDocHelper.params(self)
      example Doxxer.read_example(Comment)
      def show
        api_render(@comment)
      end

      api :POST, '/:resource_name/:resource_id/comments/', 'Create new comment'
      description 'Creates and returns the new comment if the user is allowed.'
      error code: 400, desc: 'Bad request'
      error code: 404, desc: 'Not found'
      error code: 422, desc: 'Unprocessable entity'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Comment attributes', required: true do
          param :body, String, desc: 'Body of the comment', required: true
          # rubocop:disable Metrics/LineLength
          param :'language-id', Integer, desc: 'Language id of the body content', required: true
          param :'commentable-id', String, desc: 'Id of the owner resource', required: true
          param :'commentable-type', String, desc: 'Owner resource type, i.e "jobs"', required: true
          # rubocop:enable Metrics/LineLength
        end
      end
      example Doxxer.read_example(Comment, method: :create)
      def create
        @comment = @commentable.comments.new(comment_params)
        @comment.owner_user_id = current_user.id

        if @comment.save
          api_render(@comment, status: :created)
        else
          respond_with_errors(@comment)
        end
      end

      api :PATCH, '/:resource_name/:resource_id/comments/:id', 'Update comment'
      description 'Updates and returns the comment if the user is allowed.'
      error code: 404, desc: 'Not found'
      error code: 422, desc: 'Unprocessable entity'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Comment attributes', required: true do
          param :body, String, desc: 'Body of the comment'
          param :'language-id', Integer, desc: 'Language id of the body content'
        end
      end
      example Doxxer.read_example(Comment)
      def update
        @comment = user_comment_scope.find(params[:id])
        @comment.body = comment_params[:body]

        if @comment.save
          api_render(@comment)
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/:resource_name/:resource_id/comments/:id', 'Delete comment'
      description 'Deletes comment if allowed.'
      error code: 404, desc: 'Not found'
      def destroy
        @comment = user_comment_scope.find(params[:id])
        @comment.destroy

        head :no_content
      end

      private

      def user_comment_scope
        if current_user.admin?
          Comment.all
        else
          current_user.written_comments
        end
      end

      def comment_params
        jsonapi_params.permit(:body, :language_id)
      end
    end
  end
end
