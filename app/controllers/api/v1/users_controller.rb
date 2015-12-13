class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :matching_jobs, :create_message, :messages]

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
    page_index = params[:page].to_i
    relations = [:skills, :jobs, :written_comments, :language, :languages]

    @users = User.all.page(page_index).includes(relations)
    render json: @users
  end

  api :GET, '/users/:id', 'Show user'
  description 'Returns user.'
  example Doxxer.example_for(User)
  def show
    render json: @user, include: include_params
  end

  api :POST, '/users/', 'Create new user'
  description 'Creates and returns a new user.'
  param :user, Hash, desc: 'User attributes', required: true do
    param :skill_ids, Array, of: Integer, desc: 'List of skill ids', required: true
    param :name, String, desc: 'Name', required: true
    param :description, String, desc: 'Description', required: true
    param :email, String, desc: 'Email', required: true
    param :phone, String, desc: 'Phone', required: true
    param :language_id, Integer, desc: 'Primary language id for user', required: true
    param :language_ids, Array, of: Integer, desc: 'Language ids of languages that the user knows', required: true
  end
  example Doxxer.example_for(User)
  def create
    @user = User.new(user_params)

    if @user.save
      @user.skills = Skill.where(id: params[:user][:skill_ids])
      @user.languages = Language.where(id: params[:user][:language_ids])
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
    param :language_id, Integer, desc: 'Primary language id for user'
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

    @user.reset!
    head :no_content
  end

  api :POST, '/users/:id/messages', 'Create new message to user.'
  description 'Creates and returns new message.'
  param :message, Hash, desc: 'Message attributes', required: true do
    param :body, String, desc: 'Message body', required: true
    param :language_id, Integer, desc: 'Language id', required: true
  end
  example Doxxer.example_for(Message)
  def create_message
    users = User.where(id: [@user.id, current_user.id])
    chat = Chat.find_or_create_private_chat(users)

    lang = message_params[:language_id]
    body = message_params[:body]
    @message = chat.create_message(author: current_user, body: body, language_id: lang)

    if @message.valid?
      render json: @message, include: ['author', 'language', 'chat'], status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  api :GET, '/users/:user_id/messages', 'Get user messages.'
  description 'Returns the message between user and logged in user.'
  def messages
    user_ids =  @user.id + current_user.id
    users = User.where(id: user_ids)
    @messages = Chat.find_or_create_private_chat(users).messages

    render json: @messages, include: ['author', 'language', 'chat']
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

    def message_params
      params.require(:message).permit(:body, :language_id)
    end

    def user_params
      params.require(:user).permit(:name, :email, :phone, :description, :address, :language_id)
    end

    def include_params
      whitelist = %w(languages skills jobs)
      IncludeParams.new(params[:include]).permit(whitelist)
    end
end
