# frozen_string_literal: true
module Api
  module V1
    class LanguagesController < BaseController
      before_action :set_language, only: [:show, :update, :destroy]

      before_action :require_promo_code, except: [:index, :show]

      resource_description do
        short 'API for managing languages'
        name 'Languages'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      ALLOWED_INCLUDES = %i(lang_code en_name direction system_language).freeze

      api :GET, '/languages', 'List languages'
      description 'Returns a list of languages.'
      ApipieDocHelper.params(self, Index::LanguagesIndex)
      example Doxxer.read_example(Language, plural: true)
      def index
        authorize(Language)

        languages_index = Index::LanguagesIndex.new(self)
        @languages = languages_index.languages

        api_render(@languages, total: languages_index.count)
      end

      api :GET, '/languages/:id', 'Show language'
      description 'Return language.'
      error code: 404, desc: 'Not found'
      ApipieDocHelper.params(self)
      example Doxxer.read_example(Language)
      def show
        authorize(@language)

        api_render(@language)
      end

      api :POST, '/languages/', 'Create new language'
      description 'Creates and returns new language.'
      error code: 400, desc: 'Bad request'
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable entity'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Language attributes', required: true do
          param :'lang-code', String, desc: 'Language code', required: true
        end
      end
      example Doxxer.read_example(Language, method: :create)
      def create
        authorize(Language)

        @language = Language.new(language_params)

        if @language.save
          api_render(@language, status: :created)
        else
          api_render_errors(@language)
        end
      end

      api :PATCH, '/languages/:id', 'Update language'
      description 'Updates and returns the updated language.'
      error code: 400, desc: 'Bad request'
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable entity'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Language attributes', required: true do
          param :'lang-code', String, desc: 'Name'
        end
      end
      example Doxxer.read_example(Language)
      def update
        authorize(@language)

        @language = Language.find(params[:id])
        if @language.update(language_params)
          api_render(@language)
        else
          api_render_errors(@language)
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
