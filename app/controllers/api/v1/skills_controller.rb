# frozen_string_literal: true

module Api
  module V1
    class SkillsController < BaseController
      before_action :set_skill, only: %i(show edit update destroy)

      resource_description do
        short 'API for managing skills'
        name 'Skills'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      ALLOWED_INCLUDES = %w(language).freeze

      api :GET, '/skills', 'List skills'
      description 'Returns a list of skills.'
      ApipieDocHelper.params(self, Index::SkillsIndex)
      example Doxxer.read_example(Skill, plural: true)
      def index
        authorize(Skill)

        skills_index = Index::SkillsIndex.new(self)
        @skills = skills_index.skills

        api_render(@skills, total: skills_index.count)
      end

      api :GET, '/skills/:id', 'Show skill'
      description 'Returns skill.'
      error code: 404, desc: 'Not found'
      ApipieDocHelper.params(self)
      example Doxxer.read_example(Skill)
      def show
        authorize(@skill)

        api_render(@skill)
      end

      api :POST, '/skills/', 'Create new skill'
      description 'Creates and returns the new skill if the user is allowed.'
      error code: 400, desc: 'Bad request'
      error code: 401, desc: 'Unauthorized'
      error code: 422, desc: 'Unprocessable entity'
      ApipieDocHelper.params(self)
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Skill attributes', required: true do
          param :name, String, desc: 'Name', required: true
          # rubocop:disable Metrics/LineLength
          param :language_id, Integer, desc: 'Language id of the text content', required: true
          # rubocop:enable Metrics/LineLength
        end
      end
      example Doxxer.read_example(Skill, method: :create)
      def create
        authorize(Skill)

        @skill = Skill.new(skill_params)

        if @skill.save
          @skill.set_translation(skill_params)

          api_render(@skill, status: :created)
        else
          api_render_errors(@skill)
        end
      end

      api :PATCH, '/skills/:id', 'Update skill'
      description 'Updates and returns the updated skill.'
      error code: 400, desc: 'Bad request'
      error code: 401, desc: 'Unauthorized'
      error code: 404, desc: 'Not found'
      error code: 422, desc: 'Unprocessable entity'
      ApipieDocHelper.params(self)
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Skill attributes', required: true do
          param :name, String, desc: 'Name'
          param :language_id, Integer, desc: 'Language id of the text content'
        end
      end
      example Doxxer.read_example(Skill)
      def update
        authorize(@skill)

        if @skill.update(skill_params)
          @skill.set_translation(skill_params)

          api_render(@skill)
        else
          api_render_errors(@skill)
        end
      end

      api :DELETE, '/skills/:id', 'Delete skill'
      description 'Deletes skill.'
      error code: 401, desc: 'Unauthorized'
      error code: 404, desc: 'Not found'
      def destroy
        authorize(@skill)

        @skill.destroy
        head :no_content
      end

      private

      def set_skill
        @skill = policy_scope(Skill).find(params[:id])
      end

      def skill_params
        jsonapi_params.permit(:name, :language_id)
      end
    end
  end
end

# == Schema Information
#
# Table name: occupations
#
#  id          :integer          not null, primary key
#  name        :string
#  ancestry    :string
#  language_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_occupations_on_ancestry     (ancestry)
#  index_occupations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
