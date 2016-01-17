module Api
  module V1
    module Users
      class UserSkillsController < BaseController
        before_action :set_user
        before_action :set_skill, only: [:show, :edit, :update, :destroy]

        resource_description do
          resource_id 'user_skills'
          short 'API for managing user skills'
          name 'User skills'
          description '
            User skills is the relationship between a user and a skills.
          '
          formats [:json]
          api_versions '1.0'
        end

        api :GET, '/users/:user_id/skills', 'Show user skills'
        description 'Returns list of user skills if the user is allowed to.'
        def index
          page_index = params[:page].to_i
          @skills = @user.skills.page(page_index)
          render json: @skills
        end

        api :GET, '/users/:user_id/skills/:id', 'Show user skill'
        description 'Returns user skill if the user is allowed to.'
        example Doxxer.example_for(Skill)
        def show
          render json: @skill
        end

        api :POST, '/users/:user_id/skills/', 'Create new user skill'
        description 'Creates and returns new user skill if the user is allowed to.'
        error code: 400, desc: 'Bad request'
        error code: 422, desc: 'Unprocessable entity'
        error code: 401, desc: 'Unauthorized'
        param :skill, Hash, desc: 'Skill attributes', required: true do
          param :id, Integer, desc: 'Skill id', required: true
        end
        example Doxxer.example_for(Skill)
        def create
          unless @user == current_user
            render json: { error: I18n.t('invalid_credentials') }, status: :unauthorized
            return
          end

          skill_id = params[:skill][:id]

          @user_skill = UserSkill.new
          @user_skill.skill = Skill.find_by(id: skill_id)
          @user_skill.user = @user

          if @user_skill.save
            render json: @skill, status: :created
          else
            render json: @user_skill.errors, status: :unprocessable_entity
          end
        end

        api :DELETE, '/users/:user_id/skills/:id', 'Delete user skill'
        description 'Deletes user skill if the user is allowed to.'
        error code: 401, desc: 'Unauthorized'
        def destroy
          unless @user == current_user
            render json: { error: I18n.t('invalid_credentials') }, status: :unauthorized
            return
          end

          @user_skill = @user.user_skills.find_by!(skill: @skill)

          @user_skill.destroy
          head :no_content
        end

        private

        def set_user
          @user = User.find(params[:user_id])
        end

        def set_skill
          @skill = @user.skills.find(params[:id])
        end
      end
    end
  end
end
