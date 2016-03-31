# frozen_string_literal: true
module Api
  module V1
    module ApipieDocHelper
      def self.params(controller_klass, index_klass = nil)
        controller_klass.class_eval do
          # rubocop:disable Metrics/LineLength
          if controller_klass::ALLOWED_INCLUDES.any?
            param 'include', String, "Inline resources *#{controller_klass::ALLOWED_INCLUDES.join(', ')}*"
          end

          if index_klass
            param :sort, String, "Sort on *#{index_klass::SORTABLE_FIELDS.join(', ')}*"
            param 'page[number]', String, 'Page to fetch'
            param 'page[size]', String, "Page size (Default: #{index_klass::PER_PAGE}, Max: #{index_klass::MAX_PER_PAGE})"

            index_klass::ALLOWED_FILTERS.each do |filter|
              extra_explain = if index_klass::TRANSFORMABLE_FILTERS[filter] == :date_range
                                ', by range with *YYYY-MM-DD..YYYY-MM-DD*'
                              elsif index_klass::FILTER_MATCH_TYPES[filter]
                                ", matches if #{index_klass::FILTER_MATCH_TYPES[filter].to_s.humanize.downcase}"
                              else
                                ''
                              end
              param "filter[#{filter}]", String, "Filter resource by *#{filter}*#{extra_explain}"
            end
          end
          # rubocop:enable Metrics/LineLength
        end
      end
    end
  end
end
