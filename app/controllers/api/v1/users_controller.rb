class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :matching_jobs]

  resource_description do
    short 'API for managing users'
    name 'Users'
    description ''
    formats [:json]
    api_versions '1.0'
  end

  api :GET, '/users', 'List users'
  description 'Returns a list of users.'
  def index
    @users = User.all
    render json: @users
  end

  api :GET, '/users/:id', 'Show user'
  description 'Returns user.'
  example Doxxer.example_for(User)
  def show
    render json: @user, include: ['languages']
  end

  api :POST, '/users/', 'Create new user'
  description 'Creates and returns a new user.'
  param :user, Hash, desc: 'User attributes', required: true do
    param :skills, Array, of: Integer, desc: 'List of skill ids', required: true
    param :name, String, desc: 'Name', required: true
    param :description, String, desc: 'Description', required: true
    param :email, String, desc: 'Email', required: true
    param :phone, String, desc: 'Phone', required: true
    param :language_id, Integer, desc: 'Langauge id of the text content', required: true
  end
  example Doxxer.example_for(User)
  def create
    @user = User.new(user_params)
    if @user.save
      @user.skills = Skill.where(id: params[:user][:skills])
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  api :PATCH, '/users/', 'Update new user'
  description 'Updates and returns the updated user if the user is allowed to.'
  param :user, Hash, desc: 'User attributes', required: true do
    param :name, String, desc: 'Name'
    param :description, String, desc: 'Description'
    param :email, String, desc: 'Email'
    param :phone, String, desc: 'Phone'
    param :language_id, Integer, desc: 'Langauge id of the text content'
  end
  example Doxxer.example_for(User)
  def update
    unless @user == current_user
      render json: { error: 'Not authed.' }, status: 401
      return
    end

    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/users/:id', 'Delete user'
  description 'Deletes user user if the user is allowed to.'
  def destroy
    unless @user == current_user
      render json: { error: 'Not authed.' }, status: 401
      return
    end

    @user.destroy
    head :no_content
  end

  api :GET, '/users/:id/matching_jobs', 'Show matching jobs for user'
  description 'Returns the matching jobs for user if the user is allowed to.'
  def matching_jobs
     if @user == current_user
       render json: { error: 'Not authed.' }, status: 401
       return
     end

    render json: Job.matches_user(@user)
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :phone, :description, :address)
    end
end
