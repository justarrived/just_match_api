class UserSkillsController < ApplicationController
  before_action :set_user_skill, only: [:show, :edit, :update, :destroy]

  # GET /user_skills
  # GET /user_skills.json
  api :GET, '/user_skills/:id', 'Show user skills'
  description 'Show list of user skills'
  formats ['json']
  def index
    @user_skills = UserSkill.all
    render json: @user_skills
  end

  # GET /user_skills/1
  # GET /user_skills/1.json
  api :GET, '/user_skills/:id', 'Show user skill'
  description 'Show user skill'
  formats ['json']
  def show
    render json: @user_skill
  end

  # POST /user_skills
  # POST /user_skills.json
  api :POST, '/user_skills/', 'Create new user skill'
  description 'Create a new user skill'
  formats ['json']
  param :user_id, Integer, desc: 'User id'
  param :skill_id, Integer, desc: 'Skill id'
  def create
    @user_skill = UserSkill.new(user_skill_params)

    if @user_skill.save
      render json: @user_skill, status: :created
    else
      render json: @user_skill.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_skills/1
  # PATCH/PUT /user_skills/1.json
  api :PATCH, '/user_skills/:id', 'Update user skill'
  description 'Update user skill'
  formats ['json']
  param :user_id, Integer, desc: 'User id'
  param :skill_id, Integer, desc: 'Skill id'
  def update
    if @user_skill.update(user_skill_params)
      render json: @user_skill, status: :ok
    else
      render json: @user_skill.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_skills/1
  # DELETE /user_skills/1.json
  api :DELETE, '/user_skills/:id', 'Delete user skill'
  description 'Delete user skill'
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
