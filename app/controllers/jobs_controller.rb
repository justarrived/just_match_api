class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = Job.all
    render json: @jobs
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    render json: @job
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(job_params)

    if @job.save && @job.geocoded?
      @job.skills = Skill.where(id: params[:job][:skills])
      render json: @job, include: ['skills'], status: :created
    else
      render json: @job.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
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

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    render json: {}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:max_rate, :description, :job_date, :performed, :owner_user_id, :address)
    end
end
