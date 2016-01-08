module Api
  module V1
    class UsersController < BaseController
      before_action :set_user, only: [:show, :edit, :update, :destroy, :matching_jobs]

      resource_description do
        short 'API for managing users'
        name 'Users'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      api :GET, '/users', 'List users'
      description 'Returns a list of users.'
      def index
        page_index = params[:page].to_i
        relations = [:skills, :jobs, :written_comments, :language, :languages]

        @users = User.all.page(page_index).includes(relations)
        render json: @users
      end

      api :GET, '/users/:id', 'Show user'
      description 'Returns user.'
      example Doxxer.example_for(User)
      def show
        render json: @user, include: include_params
      end

      api :POST, '/users/', 'Create new user'
      description 'Creates and returns a new user.'
      param :user, Hash, desc: 'User attributes', required: true do
        # rubocop:disable Metrics/LineLength
        param :skill_ids, Array, of: Integer, desc: 'List of skill ids', required: true
        param :name, String, desc: 'Name', required: true
        param :description, String, desc: 'Description', required: true
        param :email, String, desc: 'Email', required: true
        param :phone, String, desc: 'Phone', required: true
        param :language_id, Integer, desc: 'Primary language id for user', required: true
        param :language_ids, Array, of: Integer, desc: 'Language ids of languages that the user knows', required: true
        # rubocop:enable Metrics/LineLength
      end
      example Doxxer.example_for(User)
      def create
        @user = User.new(user_params)

        if @user.save
          @user.skills = Skill.where(id: params[:user][:skill_ids])
          @user.languages = Language.where(id: params[:user][:language_ids])
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      api :PATCH, '/users/', 'Update new user'
      description 'Updates and returns the updated user if the user is allowed to.'
      param :user, Hash, desc: 'User attributes', required: true do
        param :name, String, desc: 'Name'
        param :description, String, desc: 'Description'
        param :email, String, desc: 'Email'
        param :phone, String, desc: 'Phone'
        param :language_id, Integer, desc: 'Primary language id for user'
      end
      example Doxxer.example_for(User)
      def update
        unless @user == current_user
          render json: { error: 'Not authed.' }, status: 401
          return
        end

        if @user.update(user_params)
          render json: @user, status: :ok
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/users/:id', 'Delete user'
      description 'Deletes user user if the user is allowed to.'
      def destroy
        unless @user == current_user
          render json: { error: 'Not authed.' }, status: 401
          return
        end

        @user.reset!
        head :no_content
      end

      api :GET, '/users/:id/matching_jobs', 'Show matching jobs for user'
      description 'Returns the matching jobs for user if the user is allowed to.'
      def matching_jobs
        if @user == current_user
          render json: { error: 'Not authed.' }, status: 401
          return
        end

        render json: Job.matches_user(@user)
      end

      private

      def set_user
        @user = User.find(params[:user_id])
      end

      def user_params
        whitelist = [
          :name, :email, :phone, :description, :address, :language_id, :password
        ]
        params.require(:user).permit(*whitelist)
      end

      def include_params
        whitelist = %w(languages skills jobs)
        IncludeParams.new(params[:include]).permit(whitelist)
      end
    end
  end
end
