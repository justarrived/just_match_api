# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserSkills', type: :request do
  describe 'GET /users/1/skills' do
    it 'works!' do
      user = FactoryGirl.create(:user)
      get api_v1_user_skills_path(user_id: user.to_param)
      expect(response).to have_http_status(401)
    end
  end
end

# == Schema Information
#
# Table name: user_skills
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  skill_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  proficiency          :integer
#  proficiency_by_admin :integer
#
# Indexes
#
#  index_user_skills_on_skill_id              (skill_id)
#  index_user_skills_on_skill_id_and_user_id  (skill_id,user_id) UNIQUE
#  index_user_skills_on_user_id               (user_id)
#  index_user_skills_on_user_id_and_skill_id  (user_id,skill_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (skill_id => skills.id)
#  fk_rails_...  (user_id => users.id)
#
