class Api::V1::Users::UserLanguagesController < Api::V1::BaseController
  before_action :set_user
  before_action :set_language, only: [:show, :destroy]

  resource_description do
    short 'API for managing user languages'
    name 'User languages'
    description '
      User languages is the relationship between a user and a language.
    '
    formats [:json]
    api_versions '1.0'
  end

  api :GET, '/users/:user_id/languages', 'List user languages'
  description 'Returns a list of user languages.'
  def index
    page_index = params[:page].to_i
    @languages = @user.languages.all.page(page_index)

    render json: @languages
  end

  api :GET, '/users/:user_id/languages/:id', 'Show language'
  description 'Return language.'
  example Doxxer.example_for(Language)
  def show
    render json: @language
  end

  api :POST, '/users/:user_id/languages/', 'Create new user language'
  description 'Creates and returns new user language.'
  param :language, Hash, desc: 'User language attributes', required: true do
    param :id, Integer, desc: 'Language id', required: true
  end
  example Doxxer.example_for(UserLanguage)
  def create
    unless @user == current_user
      render json: { error: 'Not authed.' }, status: 401
      return
    end

    @user_language = UserLanguage.new
    @user_language.user = @user
    @user_language.language = Language.find_by(id: user_language_params[:id])

    if @user_language.save
      render json: @user_language, status: :created
    else
      render json: @user_language.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/users/:user_id/languages/:id', 'Delete user language'
  description 'Deletes user language.'
  def destroy
    unless @user_language.user == current_user
      render json: { error: 'Not authed.' }, status: 401
      return
    end

    @user_language.destroy

    head :no_content
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_language
      @language = @user.languages.find(params[:id])
      @user_language = @user.user_languages.find_by!(language: @language)
    end

    def user_language_params
      params.require(:language).permit(:id)
    end
end
