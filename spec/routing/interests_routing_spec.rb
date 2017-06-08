# frozen_string_literal: true
# == Schema Information
#
# Table name: interests
#
#  id          :integer          not null, primary key
#  name        :string
#  language_id :integer
#  internal    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_interests_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#

require 'rails_helper'

RSpec.describe Api::V1::InterestsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/interests'
      route_path = 'api/v1/interests#index'
      expect(get: path).to route_to(route_path)
    end

    it 'routes to #show' do
      path = '/api/v1/interests/1'
      route_path = 'api/v1/interests#show'
      expect(get: path).to route_to(route_path, id: '1')
    end
  end
end
