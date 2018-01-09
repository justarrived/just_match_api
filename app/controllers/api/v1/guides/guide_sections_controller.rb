# frozen_string_literal: true

module Api
  module V1
    module Guides
      class GuideSectionsController < BaseController
        before_action :set_section, only: %i[show]

        resource_description do
          short 'API for managing guide section'
          name 'Guide sections'
          description ''
          formats [:json]
          api_versions '1.0'
        end

        ALLOWED_INCLUDES = %w[articles].freeze

        api :GET, '/guides/sections', 'List guide sections'
        description 'Returns a list of guide sections.'
        ApipieDocHelper.params(self, Index::GuideSectionsIndex)
        example Doxxer.read_example(GuideSection, plural: true)
        def index
          authorize(GuideSection)

          sections_scope = GuideSection.
                           includes(articles: %i[translations language section])
          sections_index = Index::GuideSectionsIndex.new(self)
          @sections = sections_index.sections(sections_scope)

          api_render(@sections, total: sections_index.count)
        end

        api :GET, '/guides/sections/:id_or_slug', 'Show guide section'
        description 'Returns guide section.'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self)
        example Doxxer.read_example(GuideSection)
        def show
          authorize(@section)

          api_render(@section)
        end

        private

        def set_section
          section_id = params[:section_id]
          @section = GuideSection.find_by(id: section_id)
          @section ||= GuideSectionTranslation.find_by!(slug: section_id).section
        end
      end
    end
  end
end
