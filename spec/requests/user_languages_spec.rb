# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserLanguages', type: :request do
  describe 'GET /users/1/languages' do
    it 'does not allow non-authenticated user' do
      user = FactoryGirl.create(:user)
      get api_v1_user_languages_path(user_id: user.to_param)
      expect(response).to have_http_status(401)
    end
  end
end

# == Schema Information
#
# Table name: user_languages
#
#  id                   :integer          not null, primary key
#  language_id          :integer
#  user_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  proficiency          :integer
#  proficiency_by_admin :integer
#
# Indexes
#
#  index_user_languages_on_language_id              (language_id)
#  index_user_languages_on_language_id_and_user_id  (language_id,user_id) UNIQUE
#  index_user_languages_on_user_id                  (user_id)
#  index_user_languages_on_user_id_and_language_id  (user_id,language_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (user_id => users.id)
#
