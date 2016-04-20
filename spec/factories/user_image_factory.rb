# frozen_string_literal: true
FactoryGirl.define do
  factory :user_image do
    one_time_token 'ea91a434-3381-480d-95fc-4e3efccc08b7'
    one_time_token_expires_at Time.new(2016, 02, 11, 1, 1, 1).utc
    user nil

    # Image attributes
    image_file_name { 'test.png' }
    image_content_type { 'image/png' }
    image_file_size { 1024 }

    factory :user_image_for_docs do
      id 1
      created_at Time.new(2016, 02, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 02, 12, 1, 1, 1).utc
    end
  end
end

# == Schema Information
#
# Table name: user_images
#
#  id                        :integer          not null, primary key
#  one_time_token_expires_at :datetime
#  one_time_token            :string
#  user_id                   :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  image_file_name           :string
#  image_content_type        :string
#  image_file_size           :integer
#  image_updated_at          :datetime
#
# Indexes
#
#  index_user_images_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_435d77ec18  (user_id => users.id)
#
