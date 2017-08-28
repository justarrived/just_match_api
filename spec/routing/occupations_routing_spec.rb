# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::OccupationsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/occupations'
      expect(get: path).to route_to('api/v1/occupations#index')
    end

    it 'routes to #show' do
      path = '/api/v1/occupations/1'
      expect(get: path).to route_to('api/v1/occupations#show', id: '1')
    end
  end
end

# == Schema Information
#
# Table name: occupations
#
#  id          :integer          not null, primary key
#  name        :string
#  ancestry    :string
#  language_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_occupations_on_ancestry     (ancestry)
#  index_occupations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
