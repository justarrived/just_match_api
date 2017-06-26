# frozen_string_literal: true


require 'rails_helper'

RSpec.describe Api::V1::DocumentsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      path = '/api/v1/documents/'
      route_path = 'api/v1/documents#create'
      expect(post: path).to route_to(route_path)
    end
  end
end
# == Schema Information
#
# Table name: documents
#
#  id                        :integer          not null, primary key
#  one_time_token            :string
#  one_time_token_expires_at :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  document_file_name        :string
#  document_content_type     :string
#  document_file_size        :integer
#  document_updated_at       :datetime
#  text_content              :text
#
