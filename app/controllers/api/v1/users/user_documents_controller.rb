# frozen_string_literal: true
module Api
  module V1
    module Users
      class UserDocumentsController < BaseController
        before_action :set_user, only: [:create]
        after_action :verify_authorized, except: [:create]

        api :POST, '/users/:user_id/documents/', 'User documents'
        description 'Creates a user document'
        error code: 422, desc: 'Unprocessable entity'
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'User document attributes', required: true do
            # rubocop:disable Metrics/LineLength
            param :category, UserDocument::CATEGORIES.keys, desc: 'User document category', required: true
            param :document_one_time_token, String, desc: 'Document one time token', required: true
            # rubocop:enable Metrics/LineLength
          end
        end
        example Doxxer.read_example(UserDocument, method: :create)
        def create
          authorize_create(@user)

          document_token = jsonapi_params[:document_one_time_token]
          arguments = {
            user: @user,
            category: jsonapi_params[:category],
            document: Document.find_by_one_time_token(document_token)
          }
          @user_document = UserDocument.create(**arguments)

          if @user_document.valid?
            api_render(@user_document, status: :created)
          else
            api_render_errors(@user_document)
          end
        end

        private

        def set_user
          @user = User.find(params[:user_id])
        end

        def authorize_create(user)
          raise Pundit::NotAuthorizedError unless policy(user).create_document?
        end
      end
    end
  end
end
