# frozen_string_literal: true

module Index
  class GuideSectionArticlesIndex < BaseIndex
    FILTER_MATCH_TYPES = {
      id: :in_list,
      title: { translated: :starts_with },
      slug: { translated: :starts_with },
      short_description: { translated: :starts_with },
      body: { translated: :starts_with }
    }.freeze
    ALLOWED_FILTERS = %i(id title slug short_description body).freeze
    SORTABLE_FIELDS = %i(created_at order).freeze

    def articles(scope = GuideSectionArticle)
      @articles ||= prepare_records(scope.with_translations)
    end
  end
end
