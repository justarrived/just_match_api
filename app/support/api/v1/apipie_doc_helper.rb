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
          # rubocop:enable Metrics/LineLength
        end
      end
    end
  end
end
