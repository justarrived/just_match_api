# frozen_string_literal: true
FactoryGirl.define do
  factory :document do
    category Document::CATEGORIES.keys.first
    one_time_token 'ea91a434-3381-480d-95fc-4e3efccc08b7'
    one_time_token_expires_at Time.new(2016, 2, 11, 1, 1, 1).utc

    # Document attributes
    document_file_name { 'test.doc' }
    document_content_type { 'application/msword' }
    document_file_size { 1024 }

    factory :document_for_docs do
      id 1
      created_at Time.new(2016, 2, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 2, 12, 1, 1, 1).utc
    end
  end
end

# == Schema Information
#
# Table name: documents
#
#  id                        :integer          not null, primary key
#  category                  :integer
#  one_time_token            :string
#  one_time_token_expires_at :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  document_file_name        :string
#  document_content_type     :string
#  document_file_size        :integer
#  document_updated_at       :datetime
#
