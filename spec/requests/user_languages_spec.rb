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
#  id          :integer          not null, primary key
#  language_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_user_languages_on_language_id  (language_id)
#  index_user_languages_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_0be39eaff3  (language_id => languages.id)
#  fk_rails_db4f7502c2  (user_id => users.id)
#
