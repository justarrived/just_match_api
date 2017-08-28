# frozen_string_literal: true

module Index
  class OccupationsIndex < BaseIndex
    FILTER_MATCH_TYPES = {
      id: :in_list,
      name: { translated: :starts_with },
      parent_id: {
        column: :ancestry,
        type: :in_list
      }
    }.freeze
    ALLOWED_FILTERS = %i(id name parent_id).freeze
    SORTABLE_FIELDS = %i(created_at name).freeze
    MAX_PER_PAGE = 150

    def occupations(scope = Occupation)
      @occupations ||= prepare_records(scope.with_translations)
    end
  end
end
