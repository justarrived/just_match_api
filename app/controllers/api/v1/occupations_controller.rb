# frozen_string_literal: true

module Api
  module V1
    class OccupationsController < BaseController
      resource_description do
        short 'API for managing occupations'
        name 'Occpations'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      ALLOWED_INCLUDES = %w(language).freeze

      api :GET, '/occupations', 'List occupations'
      description 'Returns a list of occupations.'
      ApipieDocHelper.params(self, Index::OccupationsIndex)
      example Doxxer.read_example(Occupation, plural: true)
      def index
        authorize(Occupation)

        occupations_index = Index::OccupationsIndex.new(self)
        @occupations = occupations_index.occupations

        api_render(@occupations, total: occupations_index.count)
      end

      api :GET, '/occupations/:id', 'Show occupation'
      description 'Returns occupation.'
      error code: 404, desc: 'Not found'
      ApipieDocHelper.params(self)
      example Doxxer.read_example(Occupation)
      def show
        @occupation = Occupation.find(params[:id])
        authorize(@occupation)

        api_render(@occupation)
      end
    end
  end
end
