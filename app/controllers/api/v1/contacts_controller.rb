# frozen_string_literal: true
module Api
  module V1
    class ContactsController < BaseController
      after_action :verify_authorized, only: []

      resource_description do
        api_versions '1.0'
        name 'Contact'
        short 'API for sending contact emails'
        description ''
        formats [:json]
      end

      api :POST, '/contacts/', 'Create contact notification'
      description 'Send contact notification.'
      error code: 422, desc: 'Unprocessable entity'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Contact attributes', required: true do
          param :name, String, desc: 'Name', required: true
          param :email, String, desc: 'Email', required: true
          param :body, String, desc: 'Body', required: true
        end
      end
      def create
        if jsonapi_params[:email].blank?
          render json: {
            errors: {
              email: [I18n.t('errors.contact.email')]
            }
          }, status: :unprocessable_entity
        else
          name = jsonapi_params[:name]
          email = jsonapi_params[:email]
          body = jsonapi_params[:body]

          ContactNotifier.call(name: name, email: email, body: body)
          head :no_content
        end
      end
    end
  end
end
