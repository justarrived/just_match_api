# frozen_string_literal: true
module Api
  module V1
    module Users
      class UserImagesController < BaseController
        before_action :set_user, only: [:show]
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
