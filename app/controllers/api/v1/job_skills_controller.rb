class Api::V1::JobSkillsController < Api::V1::BaseController
  before_action :set_job_skill, only: [:show, :edit, :update, :destroy]

  resource_description do
    name 'Job skills'
    short 'API for managing job skills'
    description '
      Job skills is the relationship between a Job and a Skill.
    '
    formats [:json]
    api_versions '1.0'
  end


  api :GET, '/job_skills/:id', 'Show job skills'
  description 'Returns a list of job skills.'
  def index
    page_index = params[:page].to_i
    @job_skills = JobSkill.all.page(page_index)
    render json: @job_skills
  end

  api :GET, '/job_skills/:id', 'Show job skill'
  description 'Returns job skill.'
  example Doxxer.example_for(JobSkill)
  def show
    render json: @job_skill
  end

  api :POST, '/job_skills/', 'Create new job skill'
  description 'Creates and returns a new job skill is user is allowed.'
  param :job_skill, Hash, desc: 'Job skill attributes', required: true do
    param :job_id, Integer, desc: 'Job id', required: true
    param :skill_id, Integer, desc: 'Skill id', required: true
  end
  example Doxxer.example_for(JobSkill)
  def create
    @job_skill = JobSkill.new(job_skill_params)
    job = current_user.jobs.find(params[:job_skill][:job_id])
    unless job
       render json: { error: 'Not authed.' }, status: 401
       return
    end

    @job_skill.job = job

    if @job_skill.save
      render json: @job_skill, status: :created
    else
      render json: @job_skill.errors, status: :unprocessable_entity
    end
  end

  api :PATCH, '/job_skills/:id', 'Update job skill'
  description 'Updates and returns the updated job skill if user is allowed.'
  param :job_skill, Hash, desc: 'Job skill attributes', required: true do
    param :skill_id, Integer, desc: 'Skill id'
  end
  example Doxxer.example_for(JobSkill)
  def update
    job = current_user.jobs.find(@job_skill.job)
    unless job
       render json: { error: 'Not authed.' }, status: 401
       return
    end

    if @job_skill.update(job_skill_params)
      render json: @job_skill, status: :ok
    else
      render json: @job_skill.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/job_skills/:id', 'Delete job skill'
  description 'Deletes job skill if user is allowed to.'
  def destroy
    job = current_user.jobs.find(@job_skill.job)
    if job
      @job_skill.destroy
    end

    head :no_content
  end

  private

    def set_job_skill
      @job_skill = JobSkill.find(params[:id])
    end

    def job_skill_params
      params.require(:job_skill).permit(:skill_id)
    end
end
