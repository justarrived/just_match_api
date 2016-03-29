# frozen_string_literal: true
module Api
  module V1
    class JobsController < BaseController
      before_action :set_job, only: [:show, :edit, :update, :matching_users]

      resource_description do
        short 'API for managing jobs'
        name 'Jobs'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      ALLOWED_INCLUDES = %w(owner company language category).freeze

      api :GET, '/jobs', 'List jobs'
      description 'Returns a list of jobs.'
      ApipieDocHelper.params(self, Index::JobsIndex)
      example Doxxer.read_example(Job, plural: true)
      def index
        authorize(Job)

        jobs_index = Index::JobsIndex.new(self)
        @jobs = jobs_index.jobs

        api_render(@jobs)
      end

      api :GET, '/jobs/:id', 'Show job'
      description 'Return job.'
      error code: 404, desc: 'Not found'
      example Doxxer.read_example(Job)
      def show
        authorize(@job)

        api_render(@job)
      end

      api :POST, '/jobs/', 'Create new job'
      description 'Creates and returns new job.'
      error code: 400, desc: 'Bad request'
      error code: 422, desc: 'Unprocessable entity'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Job attributes', required: true do
          # rubocop:disable Metrics/LineLength
          param :skill_ids, Array, of: Integer, desc: 'List of skill ids', required: true
          param :max_rate, Integer, desc: 'Max rate', required: true
          param :hours, Float, desc: 'Estmiated completion time'
          param :name, String, desc: 'Name', required: true
          param :description, String, desc: 'Description', required: true
          param :job_date, String, desc: 'Job date', required: true
          param :language_id, Integer, desc: 'Langauge id of the text content', required: true
          param :owner_user_id, Integer, desc: 'User id for the job owner', required: true
          # rubocop:enable Metrics/LineLength
        end
      end
      example Doxxer.read_example(Job)
      def create
        authorize(Job)

        @job = Job.new(permitted_attributes)
        @job.owner_user_id = current_user.id

        if @job.save
          @job.skills = Skill.where(id: jsonapi_params[:skill_ids])

          owner = @job.owner
          User.matches_job(@job, strict_match: true).each do |user|
            UserJobMatchNotifier.call(user: user, job: @job, owner: owner)
          end

          api_render(@job, status: :created)
        else
          respond_with_errors(@job)
        end
      end

      api :PATCH, '/jobs/:id', 'Update job'
      description 'Updates and returns the updated job.'
      error code: 400, desc: 'Bad request'
      error code: 401, desc: 'Unauthorized'
      error code: 403, desc: 'Forbidden'
      error code: 404, desc: 'Not found'
      error code: 422, desc: 'Unprocessable entity'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Job attributes', required: true do
          param :max_rate, Integer, desc: 'Max rate'
          param :name, String, desc: 'Name'
          param :description, String, desc: 'Description'
          param :job_date, String, desc: 'Job date'
          param :hours, Float, desc: 'Estmiated completion time'
          param :language_id, Integer, desc: 'Langauge id of the text content'
          param :owner_user_id, Integer, desc: 'User id for the job owner'
        end
      end
      example Doxxer.read_example(Job)
      def update
        authorize(@job)

        if @job.locked_for_changes?
          message = I18n.t('errors.job.locked_for_changes_error')
          response_json = {
            errors: [{ status: 403, detail: message }]
          }
          render json: response_json, status: :forbidden
          return
        end

        @job.assign_attributes(permitted_attributes)

        if @job.save
          api_render(@job)
        else
          render json: @job.errors, status: :unprocessable_entity
        end
      end

      api :GET, '/jobs/:job_id/matching_users', 'Show matching users for job'
      description 'Returns matching users for job if user is allowed.'
      error code: 401, desc: 'Unauthorized'
      error code: 404, desc: 'Not found'
      def matching_users
        authorize(@job)

        render json: User.matches_job(@job)
      end

      private

      def set_job
        @job = policy_scope(Job).find(params[:job_id])
      end

      def job_policy
        policy(@job || Job.new)
      end

      def permitted_attributes
        jsonapi_params.permit(job_policy.permitted_attributes)
      end
    end
  end
end
