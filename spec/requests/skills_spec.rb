# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Skills', type: :request do
  describe 'GET /skills' do
    it 'works!' do
      get api_v1_skills_path
      expect(response).to have_http_status(200)
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
#  fk_rails_07eab65450  (language_id => languages.id)
#
