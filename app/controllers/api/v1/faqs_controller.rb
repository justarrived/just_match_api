# frozen_string_literal: true
module Api
  module V1
    class FaqsController < BaseController
      resource_description do
        short 'API for FAQs'
        name 'FAQ'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      api :GET, '/faqs', 'List FAQs'
      description 'Returns a list of FAQs.'
      ApipieDocHelper.params(self, Index::FaqsIndex)
      example Doxxer.read_example(Faq, plural: true)
      def index
        authorize(Faq)

        faqs_index = Index::FaqsIndex.new(self)
        @faqs = faqs_index.faqs

        api_render(@faqs, total: faqs_index.count)
      end
    end
  end
end
