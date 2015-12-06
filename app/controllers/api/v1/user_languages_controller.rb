class Api::V1::UserLanguagesController < Api::V1::BaseController
  before_action :set_user_language, only: [:show, :update, :destroy]

  resource_description do
    short 'API for managing user languages'
    name 'User languages'
    description '
      User languages is the relationship between a user and a language.
    '
    formats [:json]
    api_versions '1.0'
  end

  api :GET, '/user_languages', 'List user languages'
  description 'Returns a list of user languages.'
  def index
    @user_languages = UserLanguage.all

    render json: @user_languages
  end

  api :GET, '/user_languages/:id', 'Show user language'
  description 'Return user language.'
  example Doxxer.example_for(UserLanguage)
  def show
    render json: @user_language
  end

  api :POST, '/user_languages/', 'Create new user language'
  description 'Creates and returns new user language.'
  param :user_language, Hash, desc: 'User language attributes', required: true do
    param :language_id, Integer, desc: 'Language id', required: true
  end
  example Doxxer.example_for(UserLanguage)
  def create
    unless current_user
      render json: { error: 'Not authed.' }, status: 401
      return
    end

    @user_language = UserLanguage.new(user_language_params)
    @user_language.user = current_user

    if @user_language.save
      render json: @user_language, status: :created, location: @user_language
    else
      render json: @user_language.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/user_languages/:id', 'Delete user language'
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

    def set_user_language
      @user_language = UserLanguage.find(params[:id])
    end

    def user_language_params
      params.require(:user_language).permit(:language_id)
    end
end
