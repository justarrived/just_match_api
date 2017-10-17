# frozen_string_literal: true

module Api
  module V1
    module Guides
      class GuideSectionArticlesController < BaseController
        before_action :set_article, only: %i[show]

        resource_description do
          short 'API for managing guide section article'
          name 'Guide sections article'
          description ''
          formats [:json]
          api_versions '1.0'
        end

        ALLOWED_INCLUDES = %w[sections].freeze

        api :GET, '/guides/sections/:id_or_slug/articles/:id_or_slug', 'List guide section articles' # rubocop:disable Metrics/LineLength
        description 'Returns a list of guide section articles.'
        ApipieDocHelper.params(self, Index::GuideSectionArticlesIndex)
        example Doxxer.read_example(GuideSectionArticle, plural: true)
        def index
          authorize(GuideSectionArticle)

          articles_index = Index::GuideSectionArticlesIndex.new(self)
          @articles = articles_index.articles

          api_render(@articles, total: articles_index.count)
        end

        api :GET, '/guides/sections/:id_or_slug/articles/:id_or_slug', 'Show guide section article' # rubocop:disable Metrics/LineLength
        description 'Returns guide section article.'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self)
        example Doxxer.read_example(GuideSectionArticle)
        def show
          authorize(@article)

          api_render(@article)
        end

        private

        def set_article
          article_id = params[:article_id]
          @article = GuideSectionArticle.find_by(id: article_id)
          @article ||= GuideSectionArticleTranslation.find_by!(slug: article_id).article
        end
      end
    end
  end
end
