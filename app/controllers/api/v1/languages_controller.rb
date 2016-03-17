# frozen_string_literal: true
module Api
  module V1
    class LanguagesController < BaseController
      before_action :set_language, only: [:show, :update, :destroy]

      resource_description do
        short 'API for managing languages'
        name 'Languages'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      api :GET, '/languages', 'List languages'
      description 'Returns a list of languages.'
      example Doxxer.read_example(Language, plural: true)
      def index
        authorize(Language)

        page_index = params[:page].to_i
        @languages = Language.all.page(page_index)

        api_render(@languages)
      end

      api :GET, '/languages/:id', 'Show language'
      description 'Return language.'
      example Doxxer.read_example(Language)
      def show
        authorize(@language)

        api_render(@language)
      end

      api :POST, '/languages/', 'Create new language'
      description 'Creates and returns new language.'
      error code: 400, desc: 'Bad request'
      error code: 422, desc: 'Unprocessable entity'
      error code: 401, desc: 'Unauthorized'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Language attributes', required: true do
          param :lang_code, String, desc: 'Language code', required: true
        end
      end
      example Doxxer.read_example(Language)
      def create
        authorize(Language)

        @language = Language.new(language_params)

        if @language.save
          api_render(@language, status: :created)
        else
          respond_with_errors(@language)
        end
      end

      api :PATCH, '/languages/:id', 'Update language'
      description 'Updates and returns the updated language.'
      error code: 400, desc: 'Bad request'
      error code: 422, desc: 'Unprocessable entity'
      error code: 401, desc: 'Unauthorized'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Language attributes', required: true do
          param :lang_code, String, desc: 'Name'
        end
      end
      example Doxxer.read_example(Language)
      def update
        authorize(@language)

        @language = Language.find(params[:id])
        if @language.update(language_params)
          api_render(@language)
        else
          respond_with_errors(@language)
        end
      end

      api :DELETE, '/languages/:id', 'Delete language'
      description 'Deletes language.'
      error code: 401, desc: 'Unauthorized'
      def destroy
        authorize(@language)

        @language.destroy

        head :no_content
      end

      private

      def set_language
        @language = Language.find(params[:id])
      end

      def language_params
        jsonapi_params.permit(:lang_code)
      end
    end
  end
end
