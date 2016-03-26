# frozen_string_literal: true
module Api
  module V1
    module ApipieDocHelper
      def self.params(controller_klass, klass)
        controller_klass.class_eval do
          param :sort, String, "Sort on *#{klass::SORTABLE_FIELDS.join(', ')}*"
          param 'page[number]', String, 'Page to fetch'
          # rubocop:disable Metrics/LineLength
          param 'page[size]', String, "Page size (Default: #{klass::PER_PAGE}, Max: #{klass::MAX_PER_PAGE})"
          if klass::ALLOWED_INCLUDES.any?
            param 'include', String, "Inline resources *#{klass::ALLOWED_INCLUDES.join(', ')}*"
          end
          klass::ALLOWED_FILTERS.each do |filter|
            if klass::TRANSFORMABLE_FILTERS[filter] == :date_range
              date_range_explain = ', by range with *YYYY-MM-DD..YYYY-MM-DD*'
            end
            param "filter[#{filter}]", String, "Filter resource by *#{filter}*#{date_range_explain}"
          end
          # rubocop:enable Metrics/LineLength
        end
      end
    end
  end
end
