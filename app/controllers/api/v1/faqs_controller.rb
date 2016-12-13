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

      before_action :require_promo_code, except: [:index]

      api :GET, '/faqs', 'List FAQs'
      description 'Returns a list of FAQs. There are two possible values for `category`, `newcomer` and `company`' # rubocop:disable Metrics/LineLength
      # rubocop:disable Metrics/LineLength
      example "# Response example
#{JSON.pretty_generate(StaticFAQSerializer.serializeble_resource(language_id: 1, locale: :en, key_transform: :underscore).to_h)}" # rubocop:disable Style/CommentIndentation
      # rubocop:enable Metrics/LineLength
      def index
        authorize(Faq)

        filter = JsonApiFilterParams.build(params[:filter], [:category])
        @faqs = StaticFAQSerializer.serializeble_resource(
          language_id: Language.find_by(lang_code: I18n.locale)&.id,
          locale: I18n.locale,
          filter: filter,
          key_transform: key_transform_header
        )

        render json: @faqs.to_json
      end
    end
  end
end
