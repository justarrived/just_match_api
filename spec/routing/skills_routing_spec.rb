# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SkillsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/skills'
      expect(get: path).to route_to('api/v1/skills#index')
    end

    it 'routes to #show' do
      path = '/api/v1/skills/1'
      expect(get: path).to route_to('api/v1/skills#show', id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/skills'
      expect(post: path).to route_to('api/v1/skills#create')
    end

    it 'routes to #update via PUT' do
      path = '/api/v1/skills/1'
      expect(put: path).to route_to('api/v1/skills#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      path = '/api/v1/skills/1'
      expect(patch: path).to route_to('api/v1/skills#update', id: '1')
    end

    it 'routes to #destroy' do
      path = '/api/v1/skills/1'
      expect(delete: path).to route_to('api/v1/skills#destroy', id: '1')
    end
  end
end

# == Schema Information
#
# Table name: skills
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  language_id   :integer
#  internal      :boolean          default(FALSE)
#  color         :string
#  high_priority :boolean          default(FALSE)
#
# Indexes
#
#  index_skills_on_language_id  (language_id)
#  index_skills_on_name         (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
