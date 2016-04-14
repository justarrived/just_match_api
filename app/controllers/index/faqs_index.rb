# frozen_string_literal: true
module Index
  class FaqsIndex < BaseIndex
    ALLOWED_FILTERS = %i(language_id).freeze
    SORTABLE_FIELDS = %i().freeze
    MAX_PER_PAGE = 100

    def faqs(scope = Faq)
      @faqs ||= prepare_records(scope)
    end
  end
end
