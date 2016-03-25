# frozen_string_literal: true
module Api
  module V1
    module Users
      class UserSkillsController < BaseController
        before_action :set_user
        before_action :set_skill, only: [:show, :destroy]
        before_action :set_user_skill, only: [:show, :destroy]

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
        description 'Returns list of user skills if the user is allowed.'
        error code: 404, desc: 'Not found'
        example Doxxer.read_example(UserSkill, plural: true)
        def index
          authorize(UserSkill)

          user_skills_index = Index::UserSkillsIndex.new(self)
          @user_skills = user_skills_index.user_skills(@user.user_skills)

          api_render(@user_skills, included: user_skills_index.included)
        end

        api :GET, '/users/:user_id/skills/:id', 'Show user skill'
        description 'Returns user skill if the user is allowed.'
        error code: 404, desc: 'Not found'
        example Doxxer.read_example(UserSkill)
        def show
          authorize(UserSkill)

          api_render(@user_skill, included: 'skill')
        end

        api :POST, '/users/:user_id/skills/', 'Create new user skill'
        description 'Creates and returns new user skill if the user is allowed.'
        error code: 400, desc: 'Bad request'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Skill attributes', required: true do
            param :id, Integer, desc: 'Skill id', required: true
          end
        end
        example Doxxer.read_example(UserSkill)
        def create
          @user_skill = UserSkill.new
          @user_skill.user = @user

          authorize(@user_skill)

          @user_skill.skill = Skill.find_by(id: skill_params[:id])

          if @user_skill.save
            api_render(@user_skill, included: 'skill', status: :created)
          else
            respond_with_errors(@user_skill)
          end
        end

        api :DELETE, '/users/:user_id/skills/:id', 'Delete user skill'
        description 'Deletes user skill if the user is allowed.'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        def destroy
          @user_skill = @user.user_skills.find_by!(skill: @skill)

          authorize(@user_skill)

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

        def set_user_skill
          @user_skill = @user.user_skills.find_by!(skill: @skill)
        end

        def skill_params
          jsonapi_params.permit(:id)
        end

        def pundit_user
          UserSkillPolicy::Context.new(current_user, @user)
        end
      end
    end
  end
end
