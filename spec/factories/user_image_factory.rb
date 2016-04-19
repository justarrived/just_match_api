# frozen_string_literal: true
FactoryGirl.define do
  factory :user_image do
    one_time_token 'MyString'
    user nil

    # Image attributes
    image_file_name { 'test.png' }
    image_content_type { 'image/png' }
    image_file_size { 1024 }
  end
end
