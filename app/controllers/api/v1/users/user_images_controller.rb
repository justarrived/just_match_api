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
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'User image attributes', required: true do
            param :category, UserImage::CATEGORIES.keys, desc: 'User image category', required: true # rubocop:disable Metrics/LineLength
            param :image, String, desc: 'Image (data uri, data/image)', required: true
          end
        end
        example Doxxer.read_example(UserImage, method: :create)
        def create
          authorize(UserImage)

          data_image = DataUriImage.new(user_image_params[:image])
          unless data_image.valid?
            respond_with_invalid_image_content_type
            return
          end

          attributes = {
            user: @user,
            image: data_image.image,
            category: user_image_params[:category]
          }
          @user_image = UserImage.replace_image(**attributes)

          if @user_image.valid?
            api_render(@user_image, status: :created)
          else
            api_render_errors(@user_image)
          end
        end

        api :GET, '/users/images/categories', 'Show all possible user image categories'
        description 'Returns a list of all possible user image categories.'
        example '# Example response
{
  "data": [
    {
      "id": "profile",
      "type": "user_image_categories",
      "attributes": {
        "name": "Profile",
        "description": "Profile picture",
        "language_id": 54,
        "translated_text": {
          "name": "Profile",
          "description": "Profile picture",
          "language_id": 54
        }
      }
    }
  ],
  "meta": {
    "total": 1
  }
}
'
        def categories
          authorize(User)
          resource = UserImageCategoriesSerializer.serializeble_resource(key_transform: key_transform_header) # rubocop:disable Metrics/LineLength
          render json: resource
        end

        private

        def respond_with_invalid_image_content_type
          errors = JsonApiErrors.new
          message = I18n.t('errors.user.invalid_image_content_type')
          errors.add(status: 422, detail: message)

          render json: errors, status: :unprocessable_entity
        end

        def set_user
          @user = User.find(params[:user_id])
        end

        def set_user_image
          @user_image = @user.user_images.find(params[:id])
        end

        def user_image_params
          jsonapi_params.permit(:category, :image)
        end
      end
    end
  end
end
