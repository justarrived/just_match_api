class JobUsersController < ApplicationController
  before_action :set_job_user, only: [:show, :edit, :update, :destroy]

  # GET /job_users
  # GET /job_users.json
  def index
    @job_users = JobUser.all
  end

  # GET /job_users/1
  # GET /job_users/1.json
  def show
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

    respond_to do |format|
      if @job_user.save
        format.html { redirect_to @job_user, notice: 'Job user was successfully created.' }
        format.json { render :show, status: :created, location: @job_user }
      else
        format.html { render :new }
        format.json { render json: @job_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /job_users/1
  # PATCH/PUT /job_users/1.json
  def update
    respond_to do |format|
      if @job_user.update(job_user_params)
        format.html { redirect_to @job_user, notice: 'Job user was successfully updated.' }
        format.json { render :show, status: :ok, location: @job_user }
      else
        format.html { render :edit }
        format.json { render json: @job_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /job_users/1
  # DELETE /job_users/1.json
  def destroy
    @job_user.destroy
    respond_to do |format|
      format.html { redirect_to job_users_url, notice: 'Job user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_user
      @job_user = JobUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_user_params
      params.require(:job_user).permit(:user_id, :job_id, :accepted, :role, :rate)
    end
end
