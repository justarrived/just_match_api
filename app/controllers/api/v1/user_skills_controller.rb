class Api::V1::UserSkillsController < Api::V1::BaseController
  before_action :set_user_skill, only: [:show, :edit, :update, :destroy]

  resource_description do
    short 'API for managing user skills'
    name 'User languages'
    description '
      User skills is the relationship between a user and a skill.
    '
    formats [:json]
    api_versions '1.0'
  end

  api :GET, '/user_skills/:id', 'Show user skills'
  description 'Returns list of user skills if the user is allowed to.'
  formats ['json']
  def index
    @user_skills = UserSkill.all
    render json: @user_skills
  end

  api :GET, '/user_skills/:id', 'Show user skill'
  description 'Returns user skill if the user is allowed to.'
  formats ['json']
  def show
    render json: @user_skill
  end

  api :POST, '/user_skills/', 'Create new user skill'
  description 'Creates and returns new user skill if the user is allowed to.'
  formats ['json']
  param :user_skill, Hash, desc: 'User skill attributes', required: true  do
    param :skill_id, Integer, desc: 'Skill id', required: true
  end
  def create
    unless current_user
      render json: { error: 'Not authed.' }, status: 401
      return
    end

    @user_skill = UserSkill.new(user_skill_params)
    @user_skill.user = current_user

    if @user_skill.save
      render json: @user_skill, status: :created
    else
      render json: @user_skill.errors, status: :unprocessable_entity
    end
  end

  api :PATCH, '/user_skills/:id', 'Update user skill'
  description 'Updates and returns the updated user skill if the user is allowed to.'
  formats ['json']
  param :user_skill, Hash, desc: 'User skill attributes', required: true  do
    param :skill_id, Integer, desc: 'Skill id'
  end
  def update
    unless @user_skill.user == current_user
      render json: { error: 'Not authed.' }, status: 401
      return
    end

    if @user_skill.update(user_skill_params)
      render json: @user_skill, status: :ok
    else
      render json: @user_skill.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/user_skills/:id', 'Delete user skill'
  description 'Deletes user skill if the user is allowed to.'
  formats ['json']
  def destroy
    unless @user_skill.user == current_user
      render json: { error: 'Not authed.' }, status: 401
      return
    end

    @user_skill.destroy
    head :no_content
  end

  private

    def set_user_skill
      @user_skill = UserSkill.find(params[:id])
    end

    def user_skill_params
      params.require(:user_skill).permit(:skill_id)
    end
end
