# frozen_string_literal: true

module Api
  module V1
    module ApipieDocHelper
      def self.params(controller_klass, index_klass = nil)
        controller_klass.class_eval do
          # rubocop:disable Metrics/LineLength
          param 'fields[model_type]', String, 'Require only certain fields (comma separated) [jsonapi.org spec](http://jsonapi.org/format/#fetching-sparse-fieldsets)'

          if controller_klass::ALLOWED_INCLUDES.any?
            include_resources = controller_klass::ALLOWED_INCLUDES.map(&:to_s)
            param 'include', String, "Inline resources *#{include_resources.join(', ')}* [jsonapi.org spec](http://jsonapi.org/format/#fetching-includes)"
          end

          if index_klass
            sortable_fields = index_klass::SORTABLE_FIELDS.map(&:to_s)
            if sortable_fields.any?
              param :sort, String, "Sort on *#{sortable_fields.join(', ')}* (comma separated) [jsonapi.org spec](http://jsonapi.org/format/#fetching-sorting)"
            end
            param 'page[number]', String, 'Page to fetch [jsonapi.org spec](http://jsonapi.org/format/#fetching-pagination)'
            param 'page[size]', String, "Page size (Default: #{index_klass::PER_PAGE}, Max: #{index_klass::MAX_PER_PAGE}) [jsonapi.org spec](http://jsonapi.org/format/#fetching-pagination)"

            index_klass::ALLOWED_FILTERS.each do |filter|
              formatted_filter = filter.to_s
              filter_match_type = index_klass::FILTER_MATCH_TYPES[filter]
              extra_explain = if index_klass::TRANSFORMABLE_FILTERS[filter] == :date_range
                                ', by range with *YYYY-MM-DD..YYYY-MM-DD*'
                              elsif filter_match_type && filter_match_type != :fake_attribute
                                ", matches if #{index_klass::FILTER_MATCH_TYPES[filter].to_s.humanize.downcase}"
                              else
                                ''
                              end
              param "filter[#{formatted_filter}]", String, "Filter resource by *#{formatted_filter}*#{extra_explain} [jsonapi.org spec](http://jsonapi.org/format/#fetching-filtering)"
            end
          end
          # rubocop:enable Metrics/LineLength
        end
      end
    end
  end
end
