# frozen_string_literal: true
module Api
  module V1
    module Users
      class UserImagesController < BaseController
        before_action :set_user_image, only: [:show]

        api :POST, '/users/images/', 'User images'
        description 'Creates a user image'
        error code: 422, desc: 'Unprocessable entity'
        param :image, File, desc: 'Image (multipart/form-data)', required: true
        example Doxxer.read_example(UserImage, method: :create)
        def create
          authorize(UserImage)

          @user_image = UserImage.new(image: params[:image])

          if @user_image.save
            api_render(@user_image, status: :created)
          else
            respond_with_errors(@user_image)
          end
        end

        api :GET, '/users/:user_id/images/:id', 'Show user image'
        description 'Return user image'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        param :image, File, desc: 'Image (multipart/form-data)', required: true
        example Doxxer.read_example(UserImage, method: :create)
        def show
          authorize(@user_image)

          api_render(@user_image)
        end

        private

        def set_user_image
          @user_image = UserImage.find(params[:id])
        end
      end
    end
  end
end
