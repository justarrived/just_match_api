# frozen_string_literal: true
module Api
  module V1
    class CategoriesController < BaseController
      resource_description do
        short 'API for categories'
        name 'Categories'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      api :GET, '/categories', 'List categories'
      description 'Returns a list of categories.'
      ApipieDocHelper.params(self, Index::CategoriesIndex)
      example Doxxer.read_example(Category, plural: true)
      def index
        authorize(Category)

        categories_index = Index::CategoriesIndex.new(self)
        @categories = categories_index.categories

        api_render(@categories)
      end
    end
  end
end
