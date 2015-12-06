class Api::V1::LanguagesController < Api::V1::BaseController
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
    @languages = Language.all

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
  param :job, Hash, desc: 'Language attributes', required: true do
    param :lang_code, String, desc: 'Language code', required: true
  end
  example Doxxer.example_for(Language)
  def create
    unless current_user.admin?
      render json: { error: 'Not authed.' }, status: 401
      return
    end

    @language = Language.new(language_params)

    if @language.save
      render json: @language, status: :created, location: @language
    else
      render json: @language.errors, status: :unprocessable_entity
    end
  end

  api :PATCH, '/languages/:id', 'Update language'
  description 'Updates and returns the updated language.'
  param :job, Hash, desc: 'Language attributes', required: true do
    param :lang_code, String, desc: 'Name'
  end
  example Doxxer.example_for(Language)
  def update
    unless current_user.admin?
      render json: { error: 'Not authed.' }, status: 401
      return
    end

    @language = Language.find(params[:id])

    if @language.update(language_params)
      head :no_content
    else
      render json: @language.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/languages/:id', 'Delete language'
  description 'Deletes language.'
  def destroy
    if current_user.admin?
      @language.destroy
    else
      render json: { error: 'Not authed.' }, status: 401
    end

    head :no_content
  end

  private

    def set_language
      @language = Language.find(params[:id])
    end

    def language_params
      params.require(:language).permit(:lang_code, :primary)
    end
end
