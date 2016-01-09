module Api
  module V1
    module Jobs
      class JobSkillsController < BaseController
        before_action :set_job
        before_action :set_skill, only: [:show, :edit, :update, :destroy]

        resource_description do
          resource_id 'job_skills'
          short 'API for managing job skills'
          name 'Job skills'
          description '
            Job skills is the relationship between a job and a skills.
          '
          formats [:json]
          api_versions '1.0'
        end

        api :GET, '/jobs/:job_id/skills', 'Show user skills'
        description 'Returns list of job skills.'
        def index
          page_index = params[:page].to_i
          @skills = @job.skills.page(page_index)
          render json: @skills
        end

        api :GET, '/jobs/:job_id/skills/:id', 'Show user skill'
        description 'Returns skill.'
        example Doxxer.example_for(Skill)
        def show
          render json: @skill
        end

        api :POST, '/jobs/:job_id/skills/', 'Create new job skill'
        description 'Creates and returns new job skill if the user is allowed to.'
        error code: 422, desc: 'Unprocessable entity'
        error code: 401, desc: 'Unauthorized'
        param :skill, Hash, desc: 'Skill attributes', required: true  do
          param :id, Integer, desc: 'Skill id', required: true
        end
        example Doxxer.example_for(Skill)
        def create
          unless @job.owner == current_user
            render json: { error: I18n.t('invalid_credentials') }, status: :unauthorized
            return
          end

          skill_id = params[:skill][:id]

          @job_skill = JobSkill.new
          @job_skill.skill = Skill.find_by(id: skill_id)
          @job_skill.job = @job

          if @job_skill.save
            render json: @skill, status: :created
          else
            render json: @job_skill.errors, status: :unprocessable_entity
          end
        end

        api :DELETE, '/jobs/:job_id/skills/:id', 'Delete user skill'
        description 'Deletes job skill if the user is allowed to.'
        error code: 401, desc: 'Unauthorized'
        def destroy
          unless @job.owner == current_user
            render json: { error: I18n.t('invalid_credentials') }, status: :unauthorized
            return
          end

          @job_skill = @job.job_skills.find_by!(skill: @skill)

          @job_skill.destroy
          head :no_content
        end

        private

        def set_job
          @job = Job.find(params[:job_id])
        end

        def set_skill
          @skill = @job.skills.find(params[:id])
        end
      end
    end
  end
end
