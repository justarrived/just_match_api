# frozen_string_literal: true
module Api
  module V1
    module Users
      class UserImagesController < BaseController
        before_action :set_user, only: [:show, :create]
        before_action :set_user_image, only: [:show]

        api :GET, '/users/:user_id/images/:id', 'Show user image'
        description 'Return user image'
        error code: 401, desc: 'Unauthorized'
        error code: 404, desc: 'Not found'
        example Doxxer.read_example(UserImage, method: :create)
        def show
          authorize(@user_image)

          api_render(@user_image)
        end

        api :POST, '/users/:user_id/images/', 'User images'
        description 'Creates a user image'
        error code: 422, desc: 'Unprocessable entity'
        param :image, File, desc: 'Image (multipart/form-data)', required: true
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'User image attributes', required: true do
            param :category, UserImage::CATEGORIES.keys, desc: 'User image category', required: true # rubocop:disable Metrics/LineLength
          end
        end
        example Doxxer.read_example(UserImage, method: :create)
        def create
          authorize(UserImage)

          attributes = {
            user: @user,
            image: params[:image],
            category: user_image_params[:category]
          }
          @user_image = UserImage.replace_image(**attributes)

          if @user_image.valid?
            api_render(@user_image, status: :created)
          else
            api_render_errors(@user_image)
          end
        end

        private

        def set_user
          @user = User.find(params[:user_id])
        end

        def set_user_image
          @user_image = @user.user_images.find(params[:id])
        end

        def user_image_params
          jsonapi_params.permit(:category)
        end
      end
    end
  end
end
