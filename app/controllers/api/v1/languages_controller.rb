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
      def index
        page_index = params[:page].to_i
        @languages = Language.all.page(page_index)

        render json: @languages
      end

      api :GET, '/languages/:id', 'Show language'
      description 'Return language.'
      example Doxxer.example_for(Language)
      def show
        render json: @language
      end

      api :POST, '/languages/', 'Create new language'
      description 'Creates and returns new language.'
      error code: 422, desc: 'Unprocessable entity'
      error code: 401, desc: 'Unauthorized'
      param :job, Hash, desc: 'Language attributes', required: true do
        param :lang_code, String, desc: 'Language code', required: true
      end
      example Doxxer.example_for(Language)
      def create
        unless current_user.admin?
          render json: { error: I18n.t('invalid_credentials') }, status: :unauthorized
          return
        end

        @language = Language.new(language_params)

        if @language.save
          render json: @language, status: :created
        else
          render json: @language.errors, status: :unprocessable_entity
        end
      end

      api :PATCH, '/languages/:id', 'Update language'
      description 'Updates and returns the updated language.'
      error code: 422, desc: 'Unprocessable entity'
      error code: 401, desc: 'Unauthorized'
      param :language, Hash, desc: 'Language attributes', required: true do
        param :lang_code, String, desc: 'Name'
      end
      example Doxxer.example_for(Language)
      def update
        unless current_user.admin?
          render json: { error: I18n.t('invalid_credentials') }, status: :unauthorized
          return
        end

        @language = Language.find(params[:id])
        if @language.update(language_params)
          render json: @language
        else
          render json: @language.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/languages/:id', 'Delete language'
      description 'Deletes language.'
      error code: 401, desc: 'Unauthorized'
      def destroy
        if current_user.admin?
          @language.destroy
        else
          render json: { error: I18n.t('invalid_credentials') }, status: :unauthorized
          return
        end

        head :no_content
      end

      private

      def set_language
        @language = Language.find(params[:id])
      end

      def language_params
        params.require(:language).permit(:lang_code)
      end
    end
  end
end
