# frozen_string_literal: true
module Api
  module V1
    class SkillsController < BaseController
      before_action :set_skill, only: [:show, :edit, :update, :destroy]

      resource_description do
        short 'API for managing skills'
        name 'Skills'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      api :GET, '/skills', 'List skills'
      description 'Returns a list of skills.'
      def index
        authorize(Skill)
        page_index = params[:page].to_i
        @skills = Skill.all.page(page_index)
        render json: @skills
      end

      api :GET, '/skills/:id', 'Show skill'
      description 'Returns skill.'
      example Doxxer.example_for(Skill)
      def show
        authorize(@skill)

        render json: @skill, include: ['language']
      end

      api :POST, '/skills/', 'Create new skill'
      description 'Creates and returns the new skill if the user is allowed.'
      error code: 400, desc: 'Bad request'
      error code: 422, desc: 'Unprocessable entity'
      error code: 401, desc: 'Unauthorized'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Skill attributes', required: true do
          param :name, String, desc: 'Name', required: true
          # rubocop:disable Metrics/LineLength
          param :language_id, Integer, desc: 'Langauge id of the text content', required: true
          # rubocop:enable Metrics/LineLength
        end
      end
      example Doxxer.example_for(Skill)
      def create
        authorize(Skill)

        @skill = Skill.new(skill_params)

        if @skill.save
          render json: @skill, status: :created
        else
          render json: @skill.errors, status: :unprocessable_entity
        end
      end

      api :PATCH, '/skills/:id', 'Update skill'
      description 'Updates and returns the updated skill.'
      error code: 400, desc: 'Bad request'
      error code: 422, desc: 'Unprocessable entity'
      error code: 401, desc: 'Unauthorized'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Skill attributes', required: true do
          param :name, String, desc: 'Name'
          param :language_id, Integer, desc: 'Langauge id of the text content'
        end
      end
      example Doxxer.example_for(Skill)
      def update
        authorize(@skill)

        if @skill.update(skill_params)
          render json: @skill, status: :ok
        else
          render json: @skill.errors, status: :unprocessable_entity
        end
      end

      api :DELETE, '/skills/:id', 'Delete skill'
      description 'Deletes skill.'
      error code: 401, desc: 'Unauthorized'
      def destroy
        authorize(@skill)

        @skill.destroy
        head :no_content
      end

      private

      def set_skill
        @skill = Skill.find(params[:id])
      end

      def skill_params
        jsonapi_params.permit(:name, :language_id)
      end
    end
  end
end
