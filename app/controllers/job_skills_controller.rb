class JobSkillsController < ApplicationController
  before_action :set_job_skill, only: [:show, :edit, :update, :destroy]

  # GET /job_skills
  # GET /job_skills.json
  def index
    @job_skills = JobSkill.all
  end

  # GET /job_skills/1
  # GET /job_skills/1.json
  def show
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

    respond_to do |format|
      if @job_skill.save
        format.html { redirect_to @job_skill, notice: 'Job skill was successfully created.' }
        format.json { render :show, status: :created, location: @job_skill }
      else
        format.html { render :new }
        format.json { render json: @job_skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /job_skills/1
  # PATCH/PUT /job_skills/1.json
  def update
    respond_to do |format|
      if @job_skill.update(job_skill_params)
        format.html { redirect_to @job_skill, notice: 'Job skill was successfully updated.' }
        format.json { render :show, status: :ok, location: @job_skill }
      else
        format.html { render :edit }
        format.json { render json: @job_skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /job_skills/1
  # DELETE /job_skills/1.json
  def destroy
    @job_skill.destroy
    respond_to do |format|
      format.html { redirect_to job_skills_url, notice: 'Job skill was successfully destroyed.' }
      format.json { head :no_content }
    end
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
