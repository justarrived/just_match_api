module Api
  module V1
    module Jobs
      class JobUsersController < BaseController
        before_action :set_job
        before_action :set_user, only: [:show, :destroy]

        resource_description do
          resource_id 'job_users'
          short 'API for managing job users'
          name 'Job users'
          description '
            Job users is the relationship between a job and a users.
          '
          formats [:json]
          api_versions '1.0'
        end

        api :GET, '/jobs/:job_id/users', 'Show job users'
        description 'Returns list of job users if the user is allowed to.'
        def index
          unless @job.owner == current_user
            render json: { error: 'Not authed.' }, status: 401
            return
          end

          page_index = params[:page].to_i
          @users = @job.users.page(page_index)
          render json: @users
        end

        api :GET, '/jobs/:job_id/users/:id', 'Show job user'
        description 'Returns user.'
        example Doxxer.example_for(User)
        def show
          unless @job.owner == current_user || @user == current_user
            render json: { error: 'Not authed.' }, status: 401
            return
          end

          render json: @user
        end

        api :POST, '/jobs/:job_id/users/', 'Create new job user'
        description 'Creates and returns new job user if the user is allowed to.'
        example Doxxer.example_for(User)
        def create
          @job_user = JobUser.new
          @job_user.user = current_user
          @job_user.job = @job

          if @job_user.save
            render json: @user, status: :created
          else
            render json: @job_user.errors, status: :unprocessable_entity
          end
        end

        api :DELETE, '/jobs/:job_id/users/:id', 'Delete user user'
        description 'Deletes job user if the user is allowed to.'
        def destroy
          unless @user == current_user
            render json: { error: 'Not authed.' }, status: 401
            return
          end

          @job_user = @job.job_users.find_by!(user: @user)

          @job_user.destroy
          head :no_content
        end

        private

        def set_job
          @job = Job.find(params[:job_id])
        end

        def set_user
          @user = @job.users.find(params[:id])
        end
      end
    end
  end
end
