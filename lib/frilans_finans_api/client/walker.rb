# frozen_string_literal: true

module FrilansFinansApi
  module Walker
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def walk(client: Client.new)
        current_page = 1
        total_pages = 2

        while total_pages >= current_page
          resource_index = index(page: current_page, client: client)
          total_pages = resource_index.total_pages

          yield(resource_index)
          current_page += 1
        end
        nil
      end
    end
  end
end
