class JobUsersController < ApplicationController
  before_action :set_job_user, only: [:show, :edit, :update, :destroy]

  # GET /job_users
  # GET /job_users.json
  def index
    @job_users = JobUser.all
    render json: @job_users
  end

  # GET /job_users/1
  # GET /job_users/1.json
  def show
    render json: @job_user
  end

  # GET /job_users/new
  def new
    @job_user = JobUser.new
  end

  # GET /job_users/1/edit
  def edit
  end

  # POST /job_users
  # POST /job_users.json
  def create
    @job_user = JobUser.new(job_user_params)

    if @job_user.save
      render json: @job_user, status: :created
      NewApplicantNotifier.call(@job_user)
    else
      render json: @job_user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /job_users/1
  # PATCH/PUT /job_users/1.json
  def update
    # TODO: Make sure only the Job#owner can change JobUser#accepted
    # TODO: Maks sure only the JobUser#user can change JobUser#rate
    @job_user.assign_attributes(job_user_params)

    notify_user = @job_user.send_accepted_notice?

    if @job_user.save
      render json: @job_user, status: :ok
      ApplicantAcceptedNotifier.call(@job_user) if notify_user
    else
      render json: @job_user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /job_users/1
  # DELETE /job_users/1.json
  def destroy
    @job_user.destroy
    render json: {}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_user
      @job_user = JobUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_user_params
      params.require(:job_user).permit(:user_id, :job_id, :accepted, :rate)
    end
end
