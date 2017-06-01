# frozen_string_literal: true

module Api
  module V1
    module Companies
      class CompanyImagesController < BaseController
        before_action :set_company_image, only: [:show]

        api :POST, '/companies/images/', 'Company images'
        description 'Creates a user image'
        error code: 422, desc: 'Unprocessable entity'
        ApipieDocHelper.params(self)
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'User image attributes', required: true do
            param :image, String, desc: 'Image (data uri, data/image)', required: true
          end
        end
        example Doxxer.read_example(CompanyImage, method: :create)
        def create
          authorize(CompanyImage)

          data_image = DataUriImage.new(company_image_params[:image])
          unless data_image.valid?
            respond_with_invalid_image_content_type
            return
          end

          @company_image = CompanyImage.new(image: data_image.image)

          if @company_image.save
            api_render(@company_image, status: :created)
          else
            api_render_errors(@company_image)
          end
        end

        api :GET, '/companies/:company_id/images/:id', 'Show company image'
        description 'Return user image'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        param :image, File, desc: 'Image (multipart/form-data)', required: true
        example Doxxer.read_example(CompanyImage, method: :create)
        def show
          authorize(@company_image)

          api_render(@company_image)
        end

        private

        def company_image_params
          jsonapi_params.permit(:image)
        end

        def respond_with_invalid_image_content_type
          errors = JsonApiErrors.new
          message = I18n.t('errors.user.invalid_image_content_type')
          errors.add(status: 422, detail: message)

          render json: errors, status: :unprocessable_entity
        end

        def set_company_image
          @company_image = CompanyImage.find(params[:id])
        end
      end
    end
  end
end
