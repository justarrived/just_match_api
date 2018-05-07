# frozen_string_literal: true

FactoryBot.define do
  factory :guide_image do
    title 'Image title'

    # Image attributes
    image_file_name { 'test.png' }
    image_content_type { 'image/png' }
    image_file_size { 1024 }
  end
end

# == Schema Information
#
# Table name: guide_images
#
#  id                 :bigint(8)        not null, primary key
#  title              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#
