class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy, :matching_users]

  # GET /jobs.json
  api :GET, '/jobs', 'List jobs'
  description 'Show list of jobs'
  formats ['json']
  def index
    @jobs = Job.all
    render json: @jobs
  end

  # GET /jobs/1.json
  api :GET, '/jobs/:id', 'Show job'
  description 'Show job'
  formats ['json']
  def show
    render json: @job
  end

  # POST /jobs.json
  api :POST, '/jobs/', 'Create new job'
  description 'Create new job'
  formats ['json']
  param :job, Hash, desc: 'Job attributes', required: true do
    param :skills, Array, of: Integer, desc: 'List of skill ids', required: true
    param :max_rate, Integer, desc: 'Max rate', required: true
    param :name, String, desc: 'Name', required: true
    param :description, String, desc: 'Description', required: true
    param :job_date, String, desc: 'Job date', required: true
    param :performed, [true, false], desc: 'Performed'
    param :owner_user_id, Integer, desc: 'User id for the job owner', required: true
  end
  def create
    @job = Job.new(job_params)

    if @job.save
      @job.skills = Skill.where(id: params[:job][:skills])
      render json: @job, include: ['skills'], status: :created
    else
      render json: @job.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /jobs/1.json
  api :PATCH, '/jobs/:id', 'Update job'
  description 'Update job'
  formats ['json']
  param :job, Hash, desc: 'Job attributes', required: true do
    param :max_rate, Integer, desc: 'Max rate', required: true
    param :name, String, desc: 'Name', required: true
    param :description, String, desc: 'Description', required: true
    param :job_date, String, desc: 'Job date', required: true
    param :performed, [true, false], desc: 'Performed'
    param :owner_user_id, Integer, desc: 'User id for the job owner', required: true
  end
  def update
    @job.assign_attributes(job_params)

    send_performed_notice = @job.send_performed_notice?

    if @job.save
      render json: @job, status: :ok
      JobPerformedNotifier.call(@job) if send_performed_notice
    else
      render json: @job.errors, status: :unprocessable_entity
    end
  end

  # DELETE /jobs/1.json
  api :DELETE, '/jobs/:id', 'Delete job'
  description 'Delete job'
  formats ['json']
  def destroy
    @job.destroy
    render json: {}
  end

  # GET /jobs/:job_id/matching_users.json
  api :GET, '/jobs/:job_id/matching_users', 'Show matching users for job'
  description 'Show matching users for job'
  formats ['json']
  def matching_users
    render json: User.matches_job(@job)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:max_rate, :description, :job_date, :performed, :owner_user_id, :address, :name)
    end
end
