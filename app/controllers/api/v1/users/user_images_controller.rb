# frozen_string_literal: true
module Api
  module V1
    module Users
      class UserImagesController < BaseController
        after_action :verify_authorized, only: []

        api :POST, '/users/images/', 'User images'
        description 'Creates a user image'
        error code: 422, desc: 'Unprocessable entity'
        param :image, String, desc: 'Image (multipart/form-data)', required: true
        example Doxxer.read_example(UserImage, method: :create)
        def create
          @user_image = UserImage.new(image: params[:image])

          if @user_image.save
            api_render(@user_image, status: :created)
          else
            respond_with_errors(@user_image)
          end
        end
      end
    end
  end
end
