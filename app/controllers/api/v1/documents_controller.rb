# frozen_string_literal: true

module Api
  module V1
    class DocumentsController < BaseController
      after_action :verify_authorized, except: [:create]

      api :POST, '/documents', 'Documents'
      description 'Creates a document'
      error code: 422, desc: 'Unprocessable entity'
      ApipieDocHelper.params(self)
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Document attributes', required: true do
          param :document, String, desc: 'Document data (data uri)', required: true
        end
      end
      example Doxxer.read_example(Document, method: :create)
      def create
        data_document = DataUriDocument.new(document_params[:document])

        unless data_document.valid?
          respond_with_invalid_document_content_type(data_document.content_type)
          return
        end

        @document = Document.create(document: data_document.document)

        if @document.valid?
          api_render(@document, status: :created)
        else
          api_render_errors(@document)
        end
      end

      private

      def respond_with_invalid_document_content_type(content_type)
        errors = JsonApiErrors.new
        message = I18n.t('errors.user.invalid_document_content_type', type: content_type)
        errors.add(status: 422, detail: message)

        render json: errors, status: :unprocessable_entity
      end

      def document_params
        jsonapi_params.permit(:document)
      end
    end
  end
end
