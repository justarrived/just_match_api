class Api::V1::UserSkillsController < ApplicationController
  before_action :set_user_skill, only: [:show, :edit, :update, :destroy]

  api :GET, '/user_skills/:id', 'Show user skills'
  description 'Returns list of user skills.'
  formats ['json']
  def index
    @user_skills = UserSkill.all
    render json: @user_skills
  end

  api :GET, '/user_skills/:id', 'Show user skill'
  description 'Returns user skill.'
  formats ['json']
  def show
    render json: @user_skill
  end

  api :POST, '/user_skills/', 'Create new user skill'
  description 'Creates and returns new user skill.'
  formats ['json']
  param :user_skill, Hash, desc: 'User skill attributes', required: true  do
    param :user_id, Integer, desc: 'User id', required: true
    param :skill_id, Integer, desc: 'Skill id', required: true
  end
  def create
    @user_skill = UserSkill.new(user_skill_params)

    if @user_skill.save
      render json: @user_skill, status: :created
    else
      render json: @user_skill.errors, status: :unprocessable_entity
    end
  end

  api :PATCH, '/user_skills/:id', 'Update user skill'
  description 'Updates and returns the updated user skill.'
  formats ['json']
  param :user_skill, Hash, desc: 'User skill attributes', required: true  do
    param :user_id, Integer, desc: 'User id', required: true
    param :skill_id, Integer, desc: 'Skill id', required: true
  end
  def update
    if @user_skill.update(user_skill_params)
      render json: @user_skill, status: :ok
    else
      render json: @user_skill.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/user_skills/:id', 'Delete user skill'
  description 'Deletes user skill.'
  formats ['json']
  def destroy
    @user_skill.destroy
    render json: {}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_skill
      @user_skill = UserSkill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_skill_params
      params.require(:user_skill).permit(:user_id, :skill_id)
    end
end
