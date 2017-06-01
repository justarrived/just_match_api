# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ContactsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      path = '/api/v1/contacts/'
      route_path = 'api/v1/contacts#create'
      expect(post: path).to route_to(route_path)
    end
  end
end
# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
