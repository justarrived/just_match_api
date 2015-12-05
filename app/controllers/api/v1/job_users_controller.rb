class Api::V1::JobUsersController < ApplicationController
  before_action :set_job_user, only: [:show, :edit, :update, :destroy]

  api :GET, '/job_users/:id', 'Show job users'
  description 'Returns a list of job users.'
  formats ['json']
  def index
    @job_users = JobUser.all
    render json: @job_users
  end

  api :GET, '/job_users/:id', 'Show job user'
  description 'Returns job user.'
  formats ['json']
  def show
    render json: @job_user
  end

  api :POST, '/job_skills/', 'Create new job user'
  description 'Creates and returns new job user.'
  formats ['json']
  param :job_user, Hash, desc: 'Job user attributes', required: true do
    param :job_id, Integer, desc: 'Job id', required: true
    param :user_id, Integer, desc: 'User id', required: true
  end
  def create
    @job_user = JobUser.new(job_user_params)

    if @job_user.save
      render json: @job_user, status: :created
      NewApplicantNotifier.call(@job_user)
    else
      render json: @job_user.errors, status: :unprocessable_entity
    end
  end

  api :PATCH, '/job_skills/:id', 'Update job user'
  description 'Updates and returns the updated job user.'
  formats ['json']
  param :job_user, Hash, desc: 'Job user attributes', required: true do
    param :job_id, Integer, desc: 'Job id'
    param :user_id, Integer, desc: 'User id'
  end
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

  api :DELETE, '/job_users/:id', 'Delete job user'
  description 'Deletes job user.'
  formats ['json']
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
