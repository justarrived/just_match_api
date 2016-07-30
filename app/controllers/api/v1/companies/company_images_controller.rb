# frozen_string_literal: true
module Api
  module V1
    module Companies
      class CompanyImagesController < BaseController
        before_action :set_company_image, only: [:show]

        api :POST, '/companies/images/', 'Company images'
        description 'Creates a user image'
        error code: 422, desc: 'Unprocessable entity'
        param :image, File, desc: 'Image (multipart/form-data)', required: true
        example Doxxer.read_example(CompanyImage, method: :create)
        def create
          authorize(CompanyImage)

          @company_image = CompanyImage.new(image: params[:image])

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

        def set_company_image
          @company_image = CompanyImage.find(params[:id])
        end
      end
    end
  end
end
