class JobSkillsController < ApplicationController
  before_action :set_job_skill, only: [:show, :edit, :update, :destroy]

  # GET /job_skills
  # GET /job_skills.json
  api :GET, '/job_skills/:id', 'Show job skills'
  description 'Show list of job skills'
  formats ['json']
  def index
    @job_skills = JobSkill.all
    render json: @job_skills
  end

  # GET /job_skills/1
  # GET /job_skills/1.json
  api :GET, '/job_skills/:id', 'Show job skill'
  description 'Show job skill'
  formats ['json']
  def show
    render json: @job_skill
  end

  # POST /job_skills
  # POST /job_skills.json
  api :POST, '/job_skills/', 'Create new job skill'
  description 'Create a new job skill'
  formats ['json']
  param :job_skill, Hash, desc: 'Job skill attributes' do
    param :job_id, Integer, desc: 'Job id', required: true
    param :skill_id, Integer, desc: 'Skill id', required: true
  end
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
  api :PATCH, '/job_skills/:id', 'Update job skill'
  description 'Update job skill'
  formats ['json']
  param :job_skill, Hash, desc: 'Job skill attributes' do
    param :job_id, Integer, desc: 'Job id'
    param :skill_id, Integer, desc: 'Skill id'
  end
  def update
    if @job_skill.update(job_skill_params)
      render json: @job_skill, status: :ok
    else
      render json: @job_skill.errors, status: :unprocessable_entity
    end
  end

  # DELETE /job_skills/1
  # DELETE /job_skills/1.json
  api :DELETE, '/job_skills/:id', 'Delete job skill'
  description 'Delete job skill'
  formats ['json']
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
