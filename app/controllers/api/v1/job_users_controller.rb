class Api::V1::JobUsersController < Api::V1::BaseController
  before_action :set_job_user, only: [:show, :edit, :update, :destroy]

  resource_description do
    name 'Job users'
    short 'API for managing job users'
    description '
      Job users is the relationship between a Job and a User.
    '
    formats [:json]
    api_versions '1.0'
  end

  api :GET, '/job_users/:id', 'Show job users'
  description 'Returns a list of job users if user is allowed.'
  def index
    @job_users = JobUser.all

    if current_user.admin?
      render json: @job_users
    else
      render json: { error: 'Not authed.' }, status: 401
    end
  end

  api :GET, '/job_users/:id', 'Show job user'
  description 'Returns job user if user is allowed to.'
  def show
    job = @job_user.job
    applicant = @job_user.user

    if job.owner == current_user || applicant == current_user
      render json: @job_user
    else
      render json: { error: 'Not authed.' }, status: 401
    end
  end

  api :POST, '/job_users/', 'Create new job user'
  description 'Creates and returns new job user if user is allowed to.'
  param :job_user, Hash, desc: 'Job user attributes', required: true do
    param :job_id, Integer, desc: 'Job id', required: true
  end
  def create
    unless current_user
      render json: { error: 'Not authed.' }, status: 401
      return
    end
    @job_user = JobUser.new(job_user_params)
    @job_user.user = current_user

    if job.user == current_user
      @job_user.rate = params[:job_user][:rate]
    end

    if @job_user.save
      render json: @job_user, status: :created
      NewApplicantNotifier.call(job_user: @job_user)
    else
      render json: @job_user.errors, status: :unprocessable_entity
    end
  end

  api :PATCH, '/job_users/:id', 'Update job user'
  description 'Updates and returns the updated job user if user is allowed to.'
  param :job_user, Hash, desc: 'Job user attributes', required: true do
    param :job_id, Integer, desc: 'Job id'
    param :user_id, Integer, desc: 'User id'
  end
  def update
    job = @job_user.job
    user = @job_user.user

    if job.owner == current_user
      @job_user.accepted = params[:job_user][:accepted]
    elsif user == current_user
      @job_user.rate = params[:job_user][:rate]
    end

    should_notify_user = @job_user.send_accepted_notice?

    if @job_user.save
      if should_notify_user
        ApplicantAcceptedNotifier.call(job_user: @job_user)
      end
      render json: @job_user, status: :ok
    else
      render json: @job_user.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/job_users/:id', 'Delete job user'
  description 'Deletes job user if user is allowed to.'
  def destroy
    if @job_user.user == current_user
      @job_user.destroy
    end
    head :no_content
  end

  private

    def set_job_user
      @job_user = JobUser.find(params[:id])
    end

    def job_user_params
      params.require(:job_user).permit(:job_id)
    end
end
