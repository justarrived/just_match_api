class JobSkillsController < ApplicationController
  before_action :set_job_skill, only: [:show, :edit, :update, :destroy]

  # GET /job_skills
  # GET /job_skills.json
  def index
    @job_skills = JobSkill.all
    render json: @job_skills
  end

  # GET /job_skills/1
  # GET /job_skills/1.json
  def show
    render json: @job_skill
  end

  # GET /job_skills/new
  def new
    @job_skill = JobSkill.new
  end

  # GET /job_skills/1/edit
  def edit
  end

  # POST /job_skills
  # POST /job_skills.json
  def create
    @job_skill = JobSkill.new(job_skill_params)

    if @job_skill.save
      render json: @job_skill, status: :created
    else
      render json: @job_skill.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /job_skills/1
  # PATCH/PUT /job_skills/1.json
  def update
    if @job_skill.update(job_skill_params)
      render json: @job_skill, status: :ok
    else
      render json: @job_skill.errors, status: :unprocessable_entity
    end
  end

  # DELETE /job_skills/1
  # DELETE /job_skills/1.json
  def destroy
    @job_skill.destroy
    render json: {}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_skill
      @job_skill = JobSkill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_skill_params
      params.require(:job_skill).permit(:job_id, :skill_id)
    end
end
