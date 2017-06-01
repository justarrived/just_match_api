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
        @categories = categories_index.categories(Category.insured)

        api_render(@categories, total: categories_index.count)
      end

      api :GET, '/categories/:id', 'Show category'
      description 'Returns a category.'
      example Doxxer.read_example(Category)
      def show
        authorize(Category)

        @category = Category.insured.find(params[:id])

        api_render(@category)
      end
    end
  end
end
